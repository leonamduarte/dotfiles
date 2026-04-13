#!/usr/bin/env bash

set -euo pipefail

CHEZMOI_ROOT="${CHEZMOI_ROOT:-$HOME/.local/share/chezmoi}"
DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.dotfiles-backup}"
CONFLICT_BACKUP_ROOT="${CONFLICT_BACKUP_ROOT:-$HOME/.local/share/dotfiles-conflicts-backup}"

if [[ ! -d "$CHEZMOI_ROOT" ]]; then
	printf 'Source do chezmoi nao encontrado: %s\n' "$CHEZMOI_ROOT" >&2
	exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
	printf 'rsync e obrigatorio para a migracao.\n' >&2
	exit 1
fi

migrate_items=(
	alacritty
	autostart
	doom
	fish
	ghostty
	kitty
	mimeapps.list
	niri
	nvim
	scripts
	starship.toml
	systemd
	wezterm
	yazi
)

review_items=(
	dot_config
	opencode
	readonly_empty_dot_codex
	templates
)

ignore_items=(
	autostart.conf.broken.1776074596
	README.md
	docs
	scripts
)

printf '== Classificacao ==\n'
printf 'Migrar:\n'
printf '  - %s\n' "${migrate_items[@]}"
printf 'Revisar antes de migrar:\n'
printf '  - %s\n' "${review_items[@]}"
printf 'Nao migrar automaticamente:\n'
printf '  - %s\n' "${ignore_items[@]}"
printf 'Sensivel:\n  - opencode (revisao manual antes do primeiro commit)\n\n'

mkdir -p "$BACKUP_ROOT" "$BACKUP_ROOT/home-backup-selected" "$CONFLICT_BACKUP_ROOT"

printf '== Backups ==\n'
if [[ ! -e "$BACKUP_ROOT/chezmoi-source" ]]; then
	cp -a "$CHEZMOI_ROOT" "$BACKUP_ROOT/chezmoi-source"
	printf '  - criado: %s\n' "$BACKUP_ROOT/chezmoi-source"
else
	printf '  - existente: %s\n' "$BACKUP_ROOT/chezmoi-source"
fi

if [[ ! -e "$BACKUP_ROOT/config-backup" ]]; then
	cp -a "$HOME/.config" "$BACKUP_ROOT/config-backup" 2>/dev/null || true
	printf '  - criado: %s\n' "$BACKUP_ROOT/config-backup"
else
	printf '  - existente: %s\n' "$BACKUP_ROOT/config-backup"
fi

for item in "${migrate_items[@]}"; do
	if [[ -e "$HOME/.config/$item" || -L "$HOME/.config/$item" ]]; then
		mkdir -p "$BACKUP_ROOT/home-backup-selected/.config"
		rsync -a --ignore-existing "$HOME/.config/$item" "$BACKUP_ROOT/home-backup-selected/.config/"
	fi
done

if [[ -e "$HOME/.gitignore" || -L "$HOME/.gitignore" ]]; then
	mkdir -p "$BACKUP_ROOT/home-backup-selected"
	rsync -a --ignore-existing "$HOME/.gitignore" "$BACKUP_ROOT/home-backup-selected/.gitignore"
fi

mkdir -p "$DOTFILES_ROOT/config/.config" "$DOTFILES_ROOT/home"

excludes=(
	--exclude='**/lazy-lock.json'
	--exclude='**/node_modules/'
	--exclude='**/.cache/'
	--exclude='**/target/'
	--exclude='*.log'
	--exclude='*.bak'
	--exclude='*.broken.*'
	--exclude='*.broken_restore.*'
	--exclude='*.file_restore.*'
)

printf '\n== Copia segura ==\n'
for item in "${migrate_items[@]}"; do
	src="$CHEZMOI_ROOT/dot_config/$item"
	if [[ ! -e "$src" ]]; then
		printf '  - SKIP: %s nao existe no source\n' "$item"
		continue
	fi

	if [[ -f "$src" ]]; then
		printf '  - arquivo: %s -> %s/config/.config/\n' "$item" "$DOTFILES_ROOT"
		rsync -a "${excludes[@]}" --ignore-existing --backup --suffix='.bak' "$src" "$DOTFILES_ROOT/config/.config/"
	else
		printf '  - diretorio: %s -> %s/config/.config/%s/\n' "$item" "$DOTFILES_ROOT" "$item"
		mkdir -p "$DOTFILES_ROOT/config/.config/$item"
		rsync -a "${excludes[@]}" --ignore-existing --backup --suffix='.bak' "$src/" "$DOTFILES_ROOT/config/.config/$item/"
	fi
done

if [[ -f "$CHEZMOI_ROOT/dot_gitignore" ]]; then
	if [[ ! -f "$DOTFILES_ROOT/home/.gitignore" ]]; then
		rsync -a "$CHEZMOI_ROOT/dot_gitignore" "$DOTFILES_ROOT/home/.gitignore"
		printf '  - home/.gitignore criado a partir de dot_gitignore\n'
	else
		printf '  - SKIP: %s/home/.gitignore ja existe\n' "$DOTFILES_ROOT"
	fi
fi

repo_gitignore="$DOTFILES_ROOT/.gitignore"
touch "$repo_gitignore"
for pattern in '**/lazy-lock.json' '**/node_modules/' '**/.cache/' '**/target/' '*.log' '*.bak'; do
	if ! grep -Fqx "$pattern" "$repo_gitignore"; then
		printf '%s\n' "$pattern" >>"$repo_gitignore"
	fi
done

sync_script="$DOTFILES_ROOT/sync.sh"
if [[ ! -f "$sync_script" ]]; then
	cat >"$sync_script" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/dotfiles"
git pull --ff-only

echo ">> Dry-run"
stow -n -t "$HOME" config home

if [[ "${1:-}" == "--apply" ]]; then
	echo
	echo ">> Applying"
	stow -t "$HOME" config
	stow -t "$HOME" home
	else
	echo
	echo ">> Revise conflitos antes de aplicar."
	echo ">> Se estiver tudo ok, rode:"
	echo "stow -t ~ config && stow -t ~ home"
fi
EOF
	chmod +x "$sync_script"
	printf '  - criado: %s\n' "$sync_script"
else
	printf '  - SKIP: %s ja existe\n' "$sync_script"
fi

printf '\n== Estrutura final ==\n'
find "$DOTFILES_ROOT" -maxdepth 3 | sort

printf '\n== Itens fora da migracao automatica ==\n'
printf '  - %s\n' "${review_items[@]}"
printf '  - opencode exige revisao manual antes do primeiro commit\n'

printf '\n== Potenciais conflitos ==\n'
"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/list-stow-conflicts.sh" || true

printf '\n== Proximo passo ==\n'
printf '  1. Revise conflitos acima.\n'
printf '  2. Nunca use stow --adopt.\n'
printf '  3. Rode: stow -n -t ~ config home\n'
printf '  4. Se estiver limpo, aplique manualmente: stow -t ~ config && stow -t ~ home\n'
