#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AI_DIR="${REPO_ROOT}/.ai"
CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE_FILE="${AI_DIR}/loop-state.json"
STOP_FLAG="${AI_DIR}/loop.stop"

mkdir -p "$AI_DIR"

print_usage() {
  echo "loop-ctl.sh — Utility for /loop command"
  echo ""
  echo "Subcommands:"
  echo "  schedule <id> <interval> <prompt>   Install cron job"
  echo "  unschedule <id>                     Remove cron job"
  echo "  stop                                Stop active loop"
  echo "  status                              Show loop state"
  echo "  run <prompt>                        Headless execution"
  echo ""
  echo "Intervals: Ns, Nm, Nh, Nd (e.g. 5m, 30m, 2h, 1d)"
}

interval_to_cron() {
  local interval="$1"
  local num="${interval%[smhd]}"
  local unit="${interval: -1}"
  case "$unit" in
    s) local mins=$(( (num + 59) / 60 )); echo "*/${mins} * * * *" ;;
    m) [ "$num" -le 59 ] && echo "*/${num} * * * *" || echo "0 */$(( (num + 59) / 60 )) * * *" ;;
    h) [ "$num" -le 23 ] && echo "0 */${num} * * *" || echo "0 0 */$(( (num + 23) / 24 )) * *" ;;
    d) echo "0 0 */${num} * *" ;;
    *) echo "*/10 * * * *" ;;
  esac
}

save_state() {
  local id="$1" interval="$2" prompt="$3" cron_expr="$4"
  cat > "$STATE_FILE" << STATEEOF
{
  "id": "${id}",
  "interval": "${interval}",
  "cron": "${cron_expr}",
  "prompt": "${prompt}",
  "createdAt": "$(date -u +"%Y-%m-%dT%H-%M-%SZ")",
  "status": "active"
}
STATEEOF
}

clear_state() {
  rm -f "$STATE_FILE"
}

cmd_clean_all() {
  local existing
  existing=$(crontab -l 2>/dev/null | grep "opencode run --agent build" || true)
  if [ -n "$existing" ]; then
    crontab -l 2>/dev/null | grep -v "opencode run --agent build" | crontab -
  fi
  rm -f "${REPO_ROOT}/.ai/loop.stop" "${REPO_ROOT}/.ai/loop-state.json" 2>/dev/null
}

cmd_schedule() {
  [ $# -lt 3 ] && { echo "USO: schedule <id> <interval> <prompt>"; exit 1; }
  local id="$1" interval="$2" prompt="$3"
  local cron_expr
  cron_expr=$(interval_to_cron "$interval")

  cmd_clean_all

  local opencode_path
  opencode_path=$(command -v opencode)
  local opencode_dir
  opencode_dir=$(dirname "${opencode_path}")

  local escaped_prompt
  escaped_prompt=$(printf '%s' "$prompt" | sed 's/"/\\"/g')

  local cron_job="${cron_expr} HOME=${HOME} PATH=${opencode_dir}:/usr/bin:/bin cd ${REPO_ROOT} && ${opencode_path} run --agent build \"${escaped_prompt}\" >> ${AI_DIR}/runs/cron-${id}.log 2>&1"

  (crontab -l 2>/dev/null; echo "${cron_job}") | crontab -
  save_state "$id" "$interval" "$prompt" "$cron_expr"
  echo "ok"
}

cmd_unschedule() {
  local id="${1:-}"
  if crontab -l 2>/dev/null | grep -q "loop-ctl.*${id}"; then
    crontab -l 2>/dev/null | grep -v "loop-ctl.*${id}" | crontab -
  fi
  if [ -f "$STATE_FILE" ] && [ "$(jq -r '.id' "$STATE_FILE" 2>/dev/null)" = "${id}" ]; then
    clear_state
  fi
  echo "ok"
}

cmd_stop() {
  touch "$STOP_FLAG"

  local ids
  ids=$(crontab -l 2>/dev/null | grep "loop-ctl" | sed 's/.*loop-ctl\.sh run //' | sed 's/ >>.*//' || true)
  if [ -n "$ids" ]; then
    crontab -l 2>/dev/null | grep -v "loop-ctl" | crontab -
  fi
  clear_state
  echo "stopped"
}

cmd_status() {
  if [ ! -f "$STATE_FILE" ]; then
    echo '{"status":"inactive"}'
    return
  fi
  cat "$STATE_FILE"
}

cmd_run() {
  local prompt="$*"

  LOCK_FILE="${AI_DIR}/loop-run.lock"
  if [ -f "$LOCK_FILE" ]; then
    local lock_pid
    lock_pid=$(cat "$LOCK_FILE" 2>/dev/null)
    if kill -0 "$lock_pid" 2>/dev/null; then
      echo "⏭️  Ejecução anterior (PID $lock_pid) ainda está rodando. Pulando este ciclo."
      exit 0
    fi
    rm -f "$LOCK_FILE"
  fi

  echo "$$" > "$LOCK_FILE"
  trap 'rm -f "$LOCK_FILE"' EXIT

  local opencode_path
  opencode_path=$(command -v opencode) || { echo "opencode not found" >&2; exit 1; }
  echo "$prompt" | "${opencode_path}" run --agent build 2>&1
}

[ $# -lt 1 ] && { print_usage; exit 1; }
MODE="$1"
shift

mkdir -p "${AI_DIR}/runs"

case "$MODE" in
  schedule) cmd_schedule "$@" ;;
  unschedule) cmd_unschedule "$@" ;;
  stop) cmd_stop ;;
  status) cmd_status ;;
  run) cmd_run "$*" ;;
  help|--help|-h) print_usage ;;
  *) echo "Unknown: $MODE"; print_usage; exit 1 ;;
esac
