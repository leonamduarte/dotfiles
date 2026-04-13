---
name: sync-dotfiles
description: Sincroniza dotfiles com GNU Stow sem adotar lixo local
---

# Sync Dotfiles

Fluxo simples para repositorio `~/dotfiles` com Stow. O repo remoto vence; o estado local atual so entra no repo apos revisao manual.

## Regras fixas

- Nunca use `stow --adopt`.
- Sempre rode inventario de conflitos antes de aplicar links.
- Se houver conflito, mova o item local para backup antes de linkar.
- `opencode/` e itens sensiveis ficam fora do primeiro commit ate revisao manual.

## Estrutura esperada

- `~/dotfiles/config/.config/...`
- `~/dotfiles/home/...`
- `~/dotfiles/sync.sh`

## Fluxo operacional

### Passo 1: Atualizar repo
```bash
cd ~/dotfiles
git pull --ff-only
```

### Passo 2: Inventariar conflitos
```bash
bash ~/.local/share/chezmoi/scripts/list-stow-conflicts.sh
```

### Passo 3: Decidir cada conflito
```bash
mkdir -p ~/.local/share/dotfiles-conflicts-backup
mv ~/.config/fish ~/.local/share/dotfiles-conflicts-backup/fish-$(date +%s)
```

### Passo 4: Dry-run
```bash
cd ~/dotfiles
stow --dotfiles -n -t ~ config home
```

### Passo 5: Aplicar manualmente so quando o dry-run estiver limpo
```bash
stow --dotfiles -t ~ config
stow --dotfiles -t ~ home
```

## Script de sync

`~/dotfiles/sync.sh` deve:

1. rodar `git pull --ff-only`
2. rodar `stow --dotfiles -n -t "$HOME" config home`
3. aplicar so com `--apply`

Exemplo:

```bash
~/dotfiles/sync.sh
~/dotfiles/sync.sh --apply
```

## Resultado esperado

- Visibilidade total do impacto antes do link.
- Nada local entra no repo automaticamente.
- O remoto continua sendo a fonte de verdade.
