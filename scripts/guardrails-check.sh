#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

fail=0
node_modules_hits=()
transient_hits=()

while IFS= read -r -d '' path; do
	if [[ ! -e "$path" && ! -L "$path" ]]; then
		continue
	fi

	if [[ "$path" == node_modules || "$path" == */node_modules || "$path" == node_modules/* || "$path" == */node_modules/* ]]; then
		node_modules_hits+=("$path")
		fail=1
	fi

	if [[ "$path" =~ (\.bak$|\.tmp$|\.swp$|~$|\.orig$|\.rej$|\.broken\..*$|\.broken_restore\..*$|\.file_restore\..*$|\.backup.*$) ]]; then
		transient_hits+=("$path")
		fail=1
	fi
done < <(git ls-files -z)

if [[ ${#node_modules_hits[@]} -gt 0 ]]; then
	printf 'ERROR: arquivos rastreados dentro de node_modules (nao permitido):\n' >&2
	printf '  - %s\n' "${node_modules_hits[@]}" >&2
fi

if [[ ${#transient_hits[@]} -gt 0 ]]; then
	printf 'ERROR: arquivos transientes/backups rastreados (nao permitido):\n' >&2
	printf '  - %s\n' "${transient_hits[@]}" >&2
fi

if [[ $fail -ne 0 ]]; then
	cat >&2 <<'EOF'

Corrija antes de commitar:
1) Garanta os padroes no .gitignore.
2) Remova do indice sem apagar arquivo local:
   git rm -r --cached -- <path>
3) Commit novamente.
EOF
	exit 1
fi

printf 'Guardrails OK: nenhum node_modules/transiente rastreado.\n'
