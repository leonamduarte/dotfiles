---
name: sync-dotfiles
description: Sincroniza dotfiles entre local e remote usando timestamps e pastas gerenciadas pelo chezmoi
---

# Sync Dotfiles

Sincronização automática baseada em timestamps - sempre mantém a versão mais recente.

## Conceito

- `~/.config/dot_config/` - arquivos locais modificados
- `~/dotfiles/` - repositório git
- `~/.local/share/chezmoi/dot_config/` - define quais pastas são gerenciadas (source of truth)

Apenas pastas rastreadas pelo chezmoi são sincronizadas automaticamente.

## Fluxo de execução

### Passo 1: Preparar ambiente
```bash
cd ~/dotfiles && git fetch origin
```

### Passo 2: Identificar pastas gerenciadas
```bash
# Lista pastas que existem no source do chezmoi
MANAGED_DIRS=$(ls -d ~/.local/share/chezmoi/dot_config/*/ 2>/dev/null | xargs -n1 basename)
```

### Passo 3: Sincronizar arquivos locais para repo
```bash
# Para cada pasta gerenciada, copia arquivos mais novos
for dir in $MANAGED_DIRS; do
  if [[ -d "$HOME/.config/dot_config/$dir" ]]; then
    rsync -av --update "$HOME/.config/dot_config/$dir/" "$HOME/dotfiles/dot_config/$dir/"
  fi
done
```

### Passo 4: Commitar se houver mudanças
```bash
cd ~/dotfiles
if git diff --quiet HEAD; then
  echo "Sem mudanças no repo - verificando remote"
else
  git add -A
  git commit -m "sync: $(date +'%Y-%m-%d %H:%M') - atualização automática"
fi
```

### Passo 5: Comparar timestamps e decidir direção
```bash
LOCAL_TIME=$(git log -1 --format="%at" HEAD 2>/dev/null || echo "0")
REMOTE_TIME=$(git log -1 --format="%at" origin/main 2>/dev/null || echo "0")

if [[ $LOCAL_TIME -gt $REMOTE_TIME ]]; then
  echo "Local mais novo - executando push"
  git push origin main
  PUSHED=1
elif [[ $REMOTE_TIME -gt $LOCAL_TIME ]]; then
  echo "Remote mais novo - executando pull"
  git pull origin main --rebase
  PULLED=1
else
  echo "Commits sincronizados"
fi
```

### Passo 6: Aplicar chezmoi se fez pull
```bash
if [[ $PULLED -eq 1 ]]; then
  chezmoi apply
fi
```

## Lógica de decisão

| Situação | Ação |
|----------|------|
| Arquivo novo no local (dentro de pasta gerenciada) | Copiar para repo, commitar, push |
| Arquivo local mais novo | Copiar para repo, commitar, push |
| Arquivo remote mais novo | Pull, apply |
| Commits sincronizados | Nenhuma ação |

## Pastas gerenciadas

O sync só atua nas 14 pastas rastreadas pelo chezmoi:

```
alacritty, autostart, doom, fish, ghostty, kitty,
lazygit, mimeapps.list, niri, nvim, opencode, wezterm, yazi
```

Arquivos em pastas fora destas são ignorados.

## Exemplo de saída

```
Sincronizando dotfiles...
Fetch origin: OK
Pastas gerenciadas: alacritty doom fish niri nvim opencode wezterm yazi ...
Sync ~/.config → ~/dotfiles: 3 arquivos atualizados
Commit: feito (sync: 2026-04-10 10:30)
Push: origin/main → 3 commits ahead
```

## Notas técnicas

- Usa `rsync --update` para copiar apenas arquivos mais novos
- Timestamps do commit Git (`--format="%at"`) para comparar
- `chezmoi apply` após pull para aplicar ao sistema
- Arquivos como `node_modules`, `.git`, telemetria Go são ignorados automaticamente pelo `.chezmoiignore`
