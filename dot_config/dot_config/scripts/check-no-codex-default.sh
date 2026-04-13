#!/usr/bin/env bash
set -euo pipefail

# Fail if implementer (Codex) is configured as default or preferred
FILE="opencode/opencode.json"
[ -f "$FILE" ] || exit 0

python3 - <<'PY'
import json, sys
path = 'opencode/opencode.json'
try:
    j = json.load(open(path, encoding='utf-8'))
except Exception as e:
    print(f"[codex guard] ERROR: failed to parse {path}: {e}")
    sys.exit(1)

default_agent = j.get('default_agent')
prefer = j.get('agents', {}).get('build', {}).get('routing', {}).get('prefer', [])

if default_agent == 'implementer' or 'implementer' in prefer:
    print("[codex guard] PRE-COMMIT FAILED: 'implementer' (gpt-5.3-codex) is set as default/preferred.")
    print("Reason: Codex is expensive and must only be used via explicit escalation. Copilot must remain the default execution path.")
    print("Action: remove 'implementer' from default_agent or build.routing.prefer in opencode/opencode.json.")
    sys.exit(1)
sys.exit(0)
PY
