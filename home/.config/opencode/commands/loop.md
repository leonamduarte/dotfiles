---
description: Run a prompt on a recurring interval or in a self-paced loop.
agent: build
---

You are a loop controller. Your job is to parse the arguments and execute the appropriate mode.

ARGUMENTS: "$ARGUMENTS"
$1 = "$1"
$2 = "$2"

[LOOP_CONFIG]
max_cycles = 10
stop_on_blocked = true
stop_on_complete = true
check_stop_flag = true
state_file = .ai/progress.md

[KNOWN_LOOPS]
linear-bug-finding → prompts/loop-linear-bug-finding.txt
security-review → prompts/loop-security-review.txt
dependency-audit → prompts/loop-dependency-audit.txt
qa-review → prompts/loop-qa-review.txt
interactive-improve → prompts/loop-interactive-improve.txt

PARSING RULES (try in order; first match wins):

1. "$1" = "stop"
   → Run: bash ~/.config/opencode/scripts/loop-ctl.sh stop
   → Tell user loop stopped

2. "$1" = "status"
   → Run: bash ~/.config/opencode/scripts/loop-ctl.sh status
   → Show the result to user

3. "$1" = "once" AND "$2" is a known loop name
   → Load the corresponding prompt file
   → Run it once
   → Summarize results

4. "$1" = "once"
   → Execute remaining args ($2..$) as a one-shot task
   → Summarize results

5. "$1" matches ^\d+[smhd]$ (interval pattern like 5m, 30m, 2h, 1d)
   → TIMED MODE
   → INTERVAL SAFETY CHECK: if interval is less than 5m (e.g. 1m, 2m, 3m, 4m):
     → WARN the user: "⚠️  Interval < 5m pode acumular processos se a execução anterior não terminar a tempo. Recomendado: mínimo 5m."
     → Ask for confirmation before proceeding. If refused, abort.
   → interval = "$1", prompt = rest of args ($2..$)
   → Generate a short ID from the prompt
   → NOTE: loop-ctl.sh schedule always cleans ALL existing loop crons first automatically.
   → Run: bash ~/.config/opencode/scripts/loop-ctl.sh schedule <id> <interval> "<prompt>"
   → Execute the prompt immediately (first run)
   → Tell user: "Loop scheduled. Any previous loops were cleaned up."

6. "$1" is a known loop name (from [KNOWN_LOOPS])
   → Load the corresponding prompt file
   → Enter SELF-PACED MODE with that prompt

7. Otherwise
   → SELF-PACED MODE with the full ARGUMENTS as prompt

SELF-PACED MODE:
Execute the prompt in cycles. Each cycle follows this protocol:

  [CYCLE START]
  1. Check if .ai/loop.stop exists → if yes, clean up and stop immediately
  2. Execute the task prompt
  3. At end, evaluate state:
     a) work complete → [CYCLE_END:done]
     b) blocked → [CYCLE_END:blocked]
     c) more work needed → [CYCLE_END:continue]
  4. Save progress to .ai/progress.md (append timestamp + summary)
  5. React based on result:
     - "done" → summarize everything and stop
     - "blocked" → explain blocker and stop
     - "continue" → increment cycle, check max_cycles, go to next cycle

  Rules:
  - Max [LOOP_CONFIG.max_cycles] cycles per session
  - If max_cycles reached, stop with summary
  - Always check .ai/loop.stop before starting a cycle
  - Save meaningful progress after each cycle
  - Each cycle is independent: re-read the prompt fresh

CRON SUBCOMMANDS (advanced usage):
  "$1" = "cron-install" → "$2" = id, "$3" = interval, $4..$ = prompt
    Run: bash ~/.config/opencode/scripts/loop-ctl.sh schedule <id> <interval> "<prompt>"
  "$1" = "cron-remove" → "$2" = id
    Run: bash ~/.config/opencode/scripts/loop-ctl.sh unschedule <id>
