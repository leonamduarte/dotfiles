# Migracao Controlada para GNU Stow

Objetivo: sair do chezmoi sem perder dados locais e sem deixar configuracoes locais contaminarem o repositorio.

## Regra operacional
- `~/dotfiles` vira a fonte de verdade.
- O estado local atual so entra no repo depois de revisao manual.
- Antes de linkar qualquer conflito, mova o arquivo local para backup.
- Nunca use `stow --adopt`.

## Fluxo recomendado
1. Rode `bash scripts/migrate-to-stow.sh`.
2. Revise o relatorio gerado pelo script.
3. Liste conflitos com `bash scripts/list-stow-conflicts.sh`.
4. Para cada conflito, escolha entre:
   - manter local e nao linkar ainda;
   - mover local para `~/.local/share/dotfiles-conflicts-backup/` e depois linkar;
   - remover o item do pacote Stow antes do primeiro commit.
5. Rode `stow -n -t ~ config home`.
6. Se o dry-run estiver limpo, aplique manualmente:

```bash
stow -t ~ config
stow -t ~ home
```

## O que o bootstrap faz
- classifica o source atual do chezmoi;
- cria backups em `~/.dotfiles-backup/`;
- monta `~/dotfiles/config/.config/...` e `~/dotfiles/home/...`;
- copia apenas itens aprovados, sem mover nada e sem sobrescrever destinos existentes;
- deixa `opencode/`, `dot_config/dot_config`, `templates/` e placeholders fora da migracao automatica;
- cria `~/dotfiles/.gitignore` e um `~/dotfiles/sync.sh` em modo seguro.

## Itens fora da migracao automatica
- `dot_config/dot_config`
- `dot_config/templates`
- `dot_config/readonly_empty_dot_codex`
- `dot_config/opencode`
- `autostart.conf.broken.*`
- `docs/`, `README.md` e scripts internos do repo chezmoi

## Sync do dia a dia
Use `~/dotfiles/sync.sh`.

- sem argumentos: faz `git pull --ff-only` e `stow -n`
- com `--apply`: aplica `stow -t ~ config` e `stow -t ~ home`

Isso mantem o fluxo previsivel: primeiro revisar, depois aplicar.
