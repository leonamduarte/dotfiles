# Chezmoi Guardrails

Este documento define um fluxo padrao para reduzir conflitos e diffs ruidosos entre multiplas maquinas.

## Principios

- Fonte de verdade: repositorio chezmoi (`~/.local/share/chezmoi`)
- Branch canonica de sincronizacao: `main`
- Nao versionar artefatos gerados (ex.: `node_modules`)
- Nao versionar arquivos de backup/transientes (`*.bak`, `*.broken.*`, `*.file_restore.*`)
- Sempre revisar remoto antes de aplicar mudancas locais

## Fluxo recomendado (multi-maquina)

1. Atualizar estado remoto antes de editar:

   ```bash
   cd ~/.local/share/chezmoi
   git fetch origin
   git log --oneline HEAD..origin/main
   ```

2. Se houver commits remotos, atualizar primeiro:

   ```bash
   git pull --rebase origin main
   chezmoi apply --force
   ```

3. Fazer alteracoes preferindo o source state:
   - editar em `~/.local/share/chezmoi/dot_config/...`, ou
   - usar `chezmoi edit <arquivo>` para evitar drift

4. Validar guardrails antes de commit:

   ```bash
   cd ~/.local/share/chezmoi
   bash scripts/guardrails-check.sh
   git status --short
   ```

5. Commit e push:

   ```bash
   git add -A
   git commit -m "sync: <contexto>"
   git push origin main
   ```

## Comandos de recuperacao

- Remover do indice sem apagar local:

  ```bash
  git rm -r --cached -- dot_config/opencode/node_modules
  ```

- Validar arquivos proibidos rastreados:

  ```bash
  git ls-files | grep -E 'node_modules|\.bak$|\.broken\.|\.file_restore\.'
  ```

## CI

O workflow `chezmoi-guardrails.yml` roda em `push` e `pull_request` e falha se detectar `node_modules` ou arquivos transientes rastreados.
