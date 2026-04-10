---
name: sync-dotfiles
description: Sincroniza dotfiles entre ~/.config, ~/dotfiles e remote
---

# Sync Dotfiles

Sincronizacao automatica de tudo que estiver sendo gerenciado pelo chezmoi em `~/.local/share/chezmoi/dot_config/`.

## Estrutura de diretorios

- `~/.config/` - arquivos locais modificados (fonte real)
- `~/.local/share/chezmoi/dot_config/` - source of truth dos itens gerenciados
- `~/dotfiles/` - repositorio git

## Escopo gerenciado

- A skill nao deve manter lista hardcoded de pastas.
- A lista de verificacao vem dinamicamente dos itens de primeiro nivel existentes em `~/.local/share/chezmoi/dot_config/`.
- Isso inclui diretorios e arquivos, por exemplo `nvim/`, `kitty/` e `mimeapps.list`.
- Tudo dentro de cada diretorio gerenciado deve ser sincronizado recursivamente.
- Se uma nova pasta for adicionada manualmente ao chezmoi/repo, ela entra automaticamente na proxima execucao.

Na pratica, isso equivale a usar o `tree -L 2 ~/.local/share/chezmoi` apenas para visualizar, mas a lista efetiva deve vir dos itens de primeiro nivel dentro de `dot_config/`.

## Fluxo de execucao

### Passo 1: Preparar ambiente
```bash
cd ~/dotfiles && git fetch origin
```

### Passo 2: Identificar itens gerenciados
```bash
CHEZMOI_ROOT="$HOME/.local/share/chezmoi/dot_config"
REPO_ROOT="$HOME/dotfiles/dot_config"

MANAGED_ENTRIES=$(for path in "$CHEZMOI_ROOT"/*; do
  [[ -e "$path" ]] || continue
  basename "$path"
done | sort)
```

### Passo 3: Sincronizar tudo para o repo
```bash
for entry in $MANAGED_ENTRIES; do
  SRC="$HOME/.config/$entry"
  DEST="$REPO_ROOT/$entry"

  if [[ -d "$SRC" ]]; then
    mkdir -p "$DEST"
    rsync -a --delete --checksum "$SRC/" "$DEST/"
  elif [[ -f "$SRC" ]]; then
    mkdir -p "$(dirname "$DEST")"
    rsync -a --checksum "$SRC" "$DEST"
  else
    echo "Ignorado: $entry nao existe em ~/.config"
  fi
done
```

Observacoes:
- Diretorios novos dentro de `nvim/`, `kitty/`, `opencode/` etc. entram automaticamente porque o `rsync` e recursivo.
- Arquivos de primeiro nivel, como `mimeapps.list`, tambem entram na verificacao.
- A fonte confiavel para saber se algo mudou e `git status --short` depois da sincronizacao, nao parse de output do `rsync`.

### Passo 4: Commitar se houver mudancas
```bash
cd ~/dotfiles
if git diff --quiet HEAD && git diff --cached --quiet HEAD; then
  echo "Sem mudancas no repo"
else
  git add -A
  git commit -m "sync: $(date +'%Y-%m-%d %H:%M') - atualizacao automatica"
fi
```

### Passo 5: Comparar timestamps e decidir direcao
```bash
LOCAL_TIME=$(git log -1 --format="%at" HEAD 2>/dev/null || echo "0")
REMOTE_TIME=$(git log -1 --format="%at" origin/main 2>/dev/null || echo "0")

if [[ $LOCAL_TIME -gt $REMOTE_TIME ]]; then
  git push origin main
  PUSHED=1
elif [[ $REMOTE_TIME -gt $LOCAL_TIME ]]; then
  git pull origin main --rebase
  PULLED=1
else
  echo "Commits sincronizados"
fi
```

### Passo 6: Aplicar chezmoi se fez pull
```bash
if [[ $PULLED -eq 1 ]]; then
  chezmoi apply --force
fi
```

## Logica de decisao

| Situacao | Acao |
|----------|------|
| Arquivo ou pasta nova dentro de item gerenciado | Sincroniza para repo, commit, push |
| Arquivo local diferente dentro de item gerenciado | Sincroniza para repo, commit, push |
| Arquivo removido localmente dentro de item gerenciado | Remove no repo, commit, push |
| Arquivo remote mais novo | Pull, apply |
| Commits sincronizados | Nenhuma acao |

## Detalhes tecnicos

- A lista de verificacao vem do conteudo real de `~/.local/share/chezmoi/dot_config/`, nao de uma lista fixa na skill
- `rsync --delete` remove do repo arquivos que nao existem mais no local
- `rsync --checksum` compara por hash, nao so timestamp
- `git status --short` apos o sync e a forma confiavel de verificar mudancas
- `chezmoi apply --force` evita prompt interativo quando algum arquivo ja mudou localmente
