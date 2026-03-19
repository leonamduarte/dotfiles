#!/bin/bash
cd "$(dirname "$0")"
stow -v -t ~/.config -d config/.config $(ls -d config/.config/*/ | xargs -n1 basename)
stow -v -t ~ shell git
