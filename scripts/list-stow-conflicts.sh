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
		target="$HOME/.config/$path"
		source="$DOTFILES_ROOT/config/.config/$path"
		if [[ -e "$target" || -L "$target" ]]; then
			if [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
				continue
			fi
			printf 'CONFLICT: %s\n' "$target"
			continue
		fi
	done < <(cd "$DOTFILES_ROOT/config/.config" && find . -type f -printf '%P\n' | sort)
fi

printf '\nConflitos em ~/:\n'
if [[ -d "$DOTFILES_ROOT/home" ]]; then
	while IFS= read -r path; do
		[[ -n "$path" ]] || continue
		target_path="$path"
		if [[ "$target_path" == dot-* ]]; then
			target_path=".${target_path#dot-}"
		fi
		target="$HOME/$target_path"
		source="$DOTFILES_ROOT/home/$path"
		if [[ -e "$target" || -L "$target" ]]; then
			if [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
				continue
			fi
			printf 'CONFLICT: %s\n' "$target"
		fi
	done < <(cd "$DOTFILES_ROOT/home" && find . -maxdepth 1 -type f -printf '%P\n' | sort)
fi
