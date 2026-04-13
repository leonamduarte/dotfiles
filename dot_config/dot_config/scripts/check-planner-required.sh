#!/usr/bin/env bash
set -euo pipefail

# Ensure planner usage is configured for large/unclear tasks
FILE_JSON="opencode/opencode.json"
if [ -f "$FILE_JSON" ]; then
	python3 - <<'PY'
import json, sys
path='opencode/opencode.json'
try:
  j=json.load(open(path,encoding='utf-8'))
except Exception as e:
  print(f"[planner guard] ERROR: failed to parse {path}: {e}")
  sys.exit(1)

use_planner = j.get('agents', {}).get('build', {}).get('routing', {}).get('use_planner_if', [])
if not set(['unclear_task','large_task']).issubset(set(use_planner)):
  print("[planner guard] PRE-COMMIT FAILED: build.routing.use_planner_if must include 'unclear_task' and 'large_task'.")
  print("Reason: Large or unclear tasks require decomposition by planner before execution.")
  print("Action: add \"use_planner_if\": [\"unclear_task\", \"large_task\"] to build.routing in opencode/opencode.json")
  sys.exit(1)
sys.exit(0)
PY
else
	# Also check build.md for a textual hint if JSON absent
	FILE_MD="opencode/agents/build.md"
	if [ -f "$FILE_MD" ]; then
		if ! grep -q "use_planner_if" "$FILE_MD" && ! grep -q "planner" "$FILE_MD"; then
			echo "[planner guard] PRE-COMMIT FAILED: build.md must document planner usage for large/unclear tasks (e.g., use_planner_if or mention 'planner')."
			echo "Reason: Large or unclear tasks require decomposition by planner before execution."
			echo "Action: update opencode/agents/build.md or opencode/opencode.json to require planner for large/unclear tasks."
			exit 1
		fi
	fi
fi
