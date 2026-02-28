# dotfiles

Repositorio de dotfiles para Linux, organizado com GNU Stow. Contem configs de shell, WM/DE e apps de terminal.

## Destaques
- Shells: Bash e Zsh
- WMs/Bars/Launcher: Hyprland, Qtile, Polybar, Rofi
- Terminais: Alacritty, Kitty, WezTerm, Ghostty, Rio
- Editores: Neovim (LazyVim) e Doom Emacs
- Outros: Yazi

## Estrutura
- `shell/` -> `.bashrc` e `.zshrc`
- `git/` -> `.gitignore`
- `config/.config/` -> configs de apps (hypr, qtile, alacritty, kitty, wezterm, etc.)
- `stow.sh` -> script helper do GNU Stow

## Requisitos
- Linux
- GNU Stow
- Dependencias opcionais conforme as configs (ex.: hyprland, qtile, alacritty, kitty, wezterm, rofi, polybar, nvim, doom-emacs)

## Instalacao rapida
O script ja esta pronto para aplicar os pacotes principais:

```bash
./stow.sh
```

## Instalacao manual
Para aplicar pacotes especificos:

```bash
stow -v -t ~ shell git config --adopt
```

Nota: `--adopt` move arquivos existentes para dentro do repo. Use com cuidado.

## Uso
1. Ajuste os arquivos dentro de `shell/` e `config/.config/`.
2. Reaplique o Stow quando adicionar novos arquivos.

## Seguranca
O `.gitignore` bloqueia arquivos sensiveis (ex.: `.ssh`, `.gnupg`, `.aws`, chaves privadas). Nao commit arquivos de credenciais.

## Workflow
- A branch `main` nao deve ser alterada diretamente.
- Trabalhe em uma branch separada (ex.: `docs/readme`) e abra PR.

## Creditos
Parte das configs (ex.: Qtile) vem de bases publicas e foram ajustadas localmente.
