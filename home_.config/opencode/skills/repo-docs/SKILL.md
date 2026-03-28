---
name: repo-docs
description: Mantém documentação derivada do repo: memory/*.md e blueprints.md
compatibility: opencode
---

## Objetivo

Manter documentação estrutural consistente com o codigo atual:
- `memory/repo_summary.md` — proposito do repositorio
- `memory/architecture.md` — arquitetura observada
- `memory/recent_changes.md` — mudancas recentes
- `blueprints.md` — estrutura atual por pasta/modulo e invariantes

## Quando usar

- Mudancas estruturais recentes (pastas, modulos, responsabilidades).
- Divergencia percebida entre codigo atual e `blueprints.md`.
- Memory files ausentes ou desatualizados.
- Apos feature ou refatoracao com impacto estrutural.

## Regras

- Escopo: atualizar apenas arquivos de documentacao listados.
- Nao escopo: analisar hotspots -> delegar para `repo_analysis`.
- Nao escopo: validar violacoes arquiteturais -> delegar para `architecture-guard`.
- Nao escopo: implementar codigo -> delegar para `feature-implement`.
- Arquivos permitidos: `memory/*.md`, `blueprints.md`.

### Criterios objetivos — Memory (Sim/Nao)

- [ ] `memory/repo_summary.md` resume o proposito do repositorio.
- [ ] `memory/architecture.md` documenta a arquitetura observada.
- [ ] `memory/recent_changes.md` registra modificacoes relevantes.
- [ ] Atualiza memory apos mudancas significativas de codigo.

### Criterios objetivos — Blueprints (Sim/Nao)

- [ ] Nao altera arquivos fora de `blueprints.md`.
- [ ] `blueprints.md` descreve apenas elementos existentes no repositorio.
- [ ] Inclui responsabilidades por pasta/modulo principais.
- [ ] Inclui invariantes arquiteturais ativos ou declara `Invariantes nao definidos`.
- [ ] Se nao houver divergencia, retorna explicitamente `Blueprint ja sincronizado`.

## Git safety

Na primeira execucao, adicionar ao `.gitignore` do projeto:

```
memory/repo_summary.md
memory/architecture.md
memory/recent_changes.md
```

## Input esperado

- Estrutura atual do repositorio.
- Conteudo atual de `blueprints.md` e `memory/*.md`, se existirem.
- Decisoes arquiteturais vigentes, se existirem.

## Output esperado

- `blueprints.md` atualizado e consistente com o codigo atual.
- `memory/*.md` atualizados.
- Lista curta das secoes ajustadas.
