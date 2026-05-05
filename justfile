# ────────────────────────────────────────────────────────────────────
# AI Loop System — justfile
# ────────────────────────────────────────────────────────────────────
# Uso: just <comando> [args]
#
# Exemplos:
#   just ai-loop linear-bug-finding
#   just ai-loop-loop security-review 2h
#   just ai-loop-cron-install dependency-audit daily
#   just ai-loop-status
# ────────────────────────────────────────────────────────────────────

alias a := ai-loop
alias al := ai-loop-loop
alias aci := ai-loop-cron-install
alias acr := ai-loop-cron-remove
alias as := ai-loop-status
alias ad := ai-loop-dry
alias aim := ai-improve
alias at := ai-timed

# Diretório do script de loop
ai_script := "home/.config/opencode/scripts/ai-loop.sh"

# ── Execução ────────────────────────────────────────────────────────

# Run AI loop once: just ai-loop <loop-name>
ai-loop LOOP="linear-bug-finding":
    bash {{ai_script}} once {{LOOP}}

# Run AI loop continuously: just ai-loop-loop <loop-name> <interval>
ai-loop-loop LOOP="linear-bug-finding" INTERVAL="1h":
    bash {{ai_script}} loop {{LOOP}} {{INTERVAL}}

# Dry-run: just ai-loop-dry <loop-name>
ai-loop-dry LOOP="linear-bug-finding":
    DRY_RUN=true bash {{ai_script}} once {{LOOP}}

# ── Timed / Improve ─────────────────────────────────────────────────

# Run improvement loop for a total duration: just ai-improve [duration]
ai-improve DURATION="30m":
    bash {{ai_script}} improve {{DURATION}}

# Run any loop for a total duration: just ai-timed <loop-name> <duration>
ai-timed LOOP="interactive-improve" DURATION="30m":
    bash {{ai_script}} timed {{LOOP}} {{DURATION}}

# ── Cron ────────────────────────────────────────────────────────────

# Install cron job: just ai-loop-cron-install <loop-name> <interval> [max-iterations]
ai-loop-cron-install LOOP INTERVAL MAX="10":
    bash {{ai_script}} cron-install {{LOOP}} {{INTERVAL}} {{MAX}}

# Remove cron job: just ai-loop-cron-remove <loop-name>
ai-loop-cron-remove LOOP:
    bash {{ai_script}} cron-remove {{LOOP}}

# ── Status ──────────────────────────────────────────────────────────

# Show AI loop system status
ai-loop-status:
    bash {{ai_script}} status

# Show last AI loop execution log
ai-loop-last:
    @if [ -f .ai/state.json ]; then \
        LOG=$$(jq -r '.logFile // ""' .ai/state.json); \
        if [ -n "$$LOG" ] && [ -f "$$LOG" ]; then \
            tail -50 "$$LOG"; \
        else \
            echo "No log file found in state."; \
        fi; \
    else \
        echo "No state file found. Run a loop first."; \
    fi

# Show AI loop run logs (latest 5)
ai-loop-logs:
    @ls -lt .ai/runs/ 2>/dev/null | head -6 || echo "No logs found."

# Reset AI loop iteration counter
ai-loop-reset:
    rm -f .ai/state.json
    echo "State reset. Next run will start from iteration 1."

# ── Help ────────────────────────────────────────────────────────────

# Show available AI loop commands
ai-loop-help:
    @echo "AI Loop System — Comandos disponíveis:"
    @echo ""
    @echo "  just ai-loop <name>           Executa uma iteração"
    @echo "  just ai-loop-loop <name> <i>  Loop contínuo com intervalo"
    @echo "  just ai-loop-dry <name>       Dry-run (mostra o que faria)"
    @echo "  just ai-loop-cron-install     Instala cron job"
    @echo "  just ai-loop-cron-remove      Remove cron job"
    @echo "  just ai-loop-status           Status do sistema"
    @echo "  just ai-loop-last             Último log de execução"
    @echo "  just ai-loop-logs             Lista logs disponíveis"
    @echo "  just ai-loop-reset            Reseta contador de iterações"
    @echo ""
    @echo "  just ai-improve <dur>        Melhoria contínua COM edição (30m, 1h)"
    @echo "  just ai-timed <loop> <dur>   Qualquer loop por tempo total"
    @echo ""
    @echo "  Loops: linear-bug-finding, security-review, dependency-audit, qa-review, interactive-improve"
    @echo "  Intervalos/Duração: 10m, 20m, 30m, 1h, 2h, 4h, 6h, 12h, daily, weekly"
