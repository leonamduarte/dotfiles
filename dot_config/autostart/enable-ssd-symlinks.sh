#!/usr/bin/env bash
set -euo pipefail

# Script to convert placeholders into symlinks pointing to SSD targets
# Run this on the machine where the SSDs are mounted (home machine).

SRC="$HOME/.local/share/chezmoi"
T1="/run/media/dev/stow/dotfiles/config/autostart/autostart.conf"
T2="/run/media/dev/stow/dotfiles/config/autostart/autostart/walker.desktop"

echo "Using chezmoi source: $SRC"

if [ ! -d "$SRC" ]; then
	echo "Error: chezmoi source directory not found: $SRC" >&2
	exit 2
fi

if [ ! -e "$T1" ]; then
	echo "Target missing: $T1" >&2
	echo "Please mount your SSD or verify the path and re-run. Exiting." >&2
	exit 3
fi

if [ ! -e "$T2" ]; then
	echo "Target missing: $T2" >&2
	echo "Please mount your SSD or verify the path and re-run. Exiting." >&2
	exit 3
fi

cd "$SRC"
TS=$(date +%s)

echo "Backing up any existing chezmoi source files and creating symlinks..."
for f in dot_config/autostart/autostart.conf dot_config/autostart/walker.desktop; do
	if [ -e "$f" ] || [ -L "$f" ]; then
		mv -v -- "$f" "${f}.file_restore.$TS" || true
	fi
done

ln -sfn "$T1" dot_config/autostart/autostart.conf
ln -sfn "$T2" dot_config/autostart/walker.desktop

echo "Staging and committing changes in chezmoi source..."
git add -A
git commit -m "chore(chezmoi): restore SSD symlinks for autostart when device present" || true
echo "Pushing to origin/main..."
git push origin main || true

echo "Running 'chezmoi apply' to propagate changes to home directory"
chezmoi --source "$SRC" apply --verbose || true

echo "Finished. The autostart entries should now be symlinks pointing to your SSD targets."
