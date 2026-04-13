# dotfiles

Repositorio de dotfiles para Linux, organizado com chezmoi. Contem configs de shell, WM/DE e apps de terminal.

## Destaques
- Shells: Bash e Zsh
- WMs/Bars/Launcher: Hyprland, Qtile, Polybar, Rofi
- Terminais: Alacritty, Kitty, WezTerm, Ghostty, Rio
- Editores: Neovim (LazyVim) e Doom Emacs
- Outros: Yazi

## Estrutura
- `dot_config/` -> `~/.config/`
- `dot_gitignore` -> `~/.gitignore`
- `.chezmoiignore` -> arquivos ignorados pelo chezmoi

## Requisitos
- Linux
- chezmoi
- Dependencias opcionais conforme as configs (ex.: qtile, alacritty, kitty, wezterm, rofi, nvim, doom-emacs)

## Instalacao rapida

```bash
git clone https://github.com/leonamduarte/dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
git checkout main
chezmoi apply --force
```

## Uso
Para reaplicar os dotfiles depois de alterar o repo:

```bash
cd ~/.local/share/chezmoi
chezmoi apply --force
```

1. Edite os arquivos dentro de `dot_config/` e `dot_gitignore`.
2. Reaplique com `chezmoi apply --force`.

## Guardrails (anti-drift)
- `node_modules` e arquivos transientes sao bloqueados por `.gitignore`.
- Validacao local: `bash scripts/guardrails-check.sh`
- Validacao em CI: `.github/workflows/chezmoi-guardrails.yml`
- Fluxo multi-maquina e recuperacao: `docs/chezmoi-guardrails.md`

## Seguranca
O `.gitignore` bloqueia arquivos sensiveis (ex.: `.ssh`, `.gnupg`, `.aws`, chaves privadas). Nao commit arquivos de credenciais.

## Workflow
- A branch principal multi-maquina e `main`.
- Prefira branch separada + PR para mudancas grandes.
- Antes de editar, sincronize com `origin/main` e reaplique com `chezmoi apply --force`.

## Creditos
Parte das configs (ex.: Qtile) vem de bases publicas e foram ajustadas localmente.
