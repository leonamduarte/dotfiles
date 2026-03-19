#!/bin/bash
cd "$(dirname "$0")"
stow -v -t ~ -d config $(ls -d config/*/ | xargs -n1 basename)
stow -v -t ~ shell git
