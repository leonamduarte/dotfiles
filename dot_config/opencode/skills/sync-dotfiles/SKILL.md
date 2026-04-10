---
name: sync-dotfiles
description: Sincroniza alterações do dotfiles entre repositório local e remoto
---

# Sync Dotfiles

Sincroniza as alterações do dotfiles entre o repositório local (chezmoi) e o remoto.

## Passo 1: Verificar alterações locais

Executar análise do repositório local:
```bash
cd ~/dotfiles && git status
```

Executar diff para ver exatamente o que mudou:
```bash
cd ~/dotfiles && git diff --stat
```

## Passo 2: Verificar alterações remotas

Buscar alterações do remoto:
```bash
cd ~/dotfiles && git fetch origin
```

Verificar commits no remoto vs local:
```bash
cd ~/dotfiles && git log --oneline HEAD..origin/main
```

## Passo 3: Comparar datas e decidir direção

Verificar data da última alteração de arquivos modificados:
```bash
cd ~/dotfiles && git log -1 --format="%ai" HEAD
cd ~/dotfiles && git log -1 --format="%ai" origin/main
```

## Passo 4: Solicitar permissão do usuário

Apresentar resumo das alterações e perguntar se deseja:
- Push das alterações locais para o remoto
- Pull das alterações remotas para o local
- Cancelar operação

## Passo 5: Executar ação

### Push (se usuário permitir)
```bash
cd ~/dotfiles && git add -A && git commit -m "sync: sincronização de alterações" && git push origin main
```

### Pull (se usuário permitir)
```bash
cd ~/dotfiles && git pull origin main
```

## Fluxo de decisão

1. Se há alterações locais E remoto está atrás → sugerir push
2. Se há alterações remotas E local está atrás → sugerir pull
3. Se há alterações em ambos → avisar sobre possível conflito e sugerir merge ou rebase
4. Se estão sincronizados → informar que não há alterações pendentes