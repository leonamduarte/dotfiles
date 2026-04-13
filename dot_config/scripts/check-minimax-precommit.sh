#!/usr/bin/env bash
set -euo pipefail

# Simple pre-commit guard: ensure 'minimax' is NOT in build.routing.prefer
# Location checked: opencode/opencode.json (repo root)

FILE="opencode/opencode.json"
if [ ! -f "$FILE" ]; then
	# nothing to check
	exit 0
fi

python3 - <<'PY'
import json, sys

path = 'opencode/opencode.json'
try:
    with open(path, 'r', encoding='utf-8') as f:
        j = json.load(f)
except Exception as e:
    print(f"[opencode guard] ERROR: failed to parse {path}: {e}")
    sys.exit(1)

prefer = []
try:
    prefer = j.get('agents', {}).get('build', {}).get('routing', {}).get('prefer', [])
except Exception:
    prefer = []

if 'minimax' in prefer:
    print("[opencode guard] PRE-COMMIT FAILED: 'minimax' found in build.routing.prefer in opencode/opencode.json")
    print("Reason: minimax is an optional/manual analysis tool and must NOT appear in the router's prefer list.")
    print("Action: remove 'minimax' from build.routing.prefer so that 'copilot-worker' remains the primary executor.")
    sys.exit(1)

sys.exit(0)
PY
