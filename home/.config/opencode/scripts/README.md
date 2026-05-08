# /loop — AI Loop Controller for OpenCode

Model-orchestrated loop command. The agent parses `/loop <args>` and decides
how to execute: self-paced cycles, cron-scheduled timed runs, or one-shot tasks.

## Architecture

```
/loop <args>
  │
  ├── Timed (cron): /loop 30m <prompt>
  │     system cron → opencode run (headless)
  │     first run NOW → schedule cron → next runs on interval
  │
  ├── Self-paced: /loop <prompt>
  │     [CYCLE_START] → execute → [CYCLE_END:continue|done|blocked]
  │
  ├── Stop: /loop stop
  └── Status: /loop status
```

## Files

| File | Role |
|---|---|
| `commands/loop.md` | `/loop` command — prompt with `$ARGUMENTS` parsing |
| `commands/proactive.md` | `/proactive` alias |
| `scripts/loop-ctl.sh` | Lightweight utility: schedule/unschedule cron, stop, status |
| `prompts/loop-*.txt` | Task templates for known loop types (bug-finding, security, etc) |

## Usage

### Timed (cron recurring) — Claude-like

```
/loop 30m audite o código e faça as melhorias sugeridas
/loop 1m "execute os testes e reporte falhas"
/loop "audite o código" every 15m
/loop stop
/loop status
```

**Como funciona:**
1. `/loop <interval> <prompt>` → executa o prompt imediatamente
2. Só após a primeira execução concluir, agenda o cron recorrente
3. A cada tick do cron: `opencode run --agent build "<prompt>"` (headless)
4. Para cancelar: `/loop stop`

**Intervalos suportados:** 1m, 5m, 30m, 2h, 4h, 1d (mínimo: 1m)

### Formatos de escrita

```
/loop 30m <prompt>           ← intervalo no início (recomendado)
/loop <prompt> every 30m     ← intervalo no final com "every"
/loop <prompt>               ← sem intervalo: default 10m
```

### Self-paced (sem intervalo)

```
/loop refatore os componentes Button e Input
/loop once qa-review
```

Executa em ciclos na mesma sessão. O modelo decide quando parar
usando `[CYCLE_END:continue|done|blocked]`.

## Dicas práticas

### Uso de aspas

- Prompts com **mais de uma palavra** podem ou não precisar de aspas.
- **Use aspas** quando houver vírgulas, `:`, `(`, `)`, `&`, `|`, `>` ou texto longo.
- Recomendado: `/loop 1m "audite o código e aplique melhorias"`
- Equivalente: `/loop "audite o código e aplique melhorias" every 1m`

### Intervalo mínimo

- Mínimo real: **1 minuto** (cron não agenda abaixo disso).
- Para teste rápido: `1m` funciona bem.

### Primeira execução

- O cron só é agendado **após a primeira execução imediata concluir**.
- Se a primeira execução falhar, o agente reporta e **não deixa cron zumbi**.

## Self-paced mode

The model executes the prompt in cycles. At the end of each cycle it emits:
- `[CYCLE_END:continue]` → next cycle
- `[CYCLE_END:done]` → stop, summarize
- `[CYCLE_END:blocked]` → stop, explain

Stop flag at `.ai/loop.stop` halts all modes.

## Timed mode (cron)

Intervals: 1m, 5m, 30m, 2h, 1d, etc. Uses system cron.
Each tick runs: `opencode run --agent build "<prompt>"` (headless).

First run happens immediately. Cron is scheduled after first run succeeds.

## Configuration

Edit `[LOOP_CONFIG]` in `commands/loop.md`:
- `max_cycles` — max self-paced cycles per session (default: 10)
- `stop_on_blocked` — stop when blocked (default: true)
- `stop_on_complete` — stop when done (default: true)
- `check_stop_flag` — check .ai/loop.stop each cycle (default: true)
- `state_file` — progress log path (default: .ai/progress.md)
- `default_interval` — fallback interval when none given (default: 10m)

## State files (in project `.ai/` directory)

| File | Purpose |
|---|---|
| `.ai/loop-state.json` | Active cron schedule |
| `.ai/loop.stop` | Stop signal (touch to stop) |
| `.ai/progress.md` | Cycle progress log |
| `.ai/runs/` | Per-run logs (from cron headless) |
