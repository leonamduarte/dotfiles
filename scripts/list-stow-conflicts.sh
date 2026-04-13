#!/usr/bin/env bash

set -euo pipefail

DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"

if [[ ! -d "$DOTFILES_ROOT/config/.config" && ! -d "$DOTFILES_ROOT/home" ]]; then
	printf 'Nada para verificar em %s\n' "$DOTFILES_ROOT" >&2
	exit 1
fi

printf 'Conflitos em ~/.config:\n'
if [[ -d "$DOTFILES_ROOT/config/.config" ]]; then
	while IFS= read -r path; do
		[[ -n "$path" ]] || continue
		if [[ -e "$HOME/.config/$path" || -L "$HOME/.config/$path" ]]; then
			printf 'CONFLICT: %s\n' "$HOME/.config/$path"
		fi
	done < <(cd "$DOTFILES_ROOT/config/.config" && find . -type f -printf '%P\n' | sort)
fi

printf '\nConflitos em ~/:\n'
if [[ -d "$DOTFILES_ROOT/home" ]]; then
	while IFS= read -r path; do
		[[ -n "$path" ]] || continue
		if [[ -e "$HOME/$path" || -L "$HOME/$path" ]]; then
			printf 'CONFLICT: %s\n' "$HOME/$path"
		fi
	done < <(cd "$DOTFILES_ROOT/home" && find . -maxdepth 1 -type f -printf '%P\n' | sort)
fi
