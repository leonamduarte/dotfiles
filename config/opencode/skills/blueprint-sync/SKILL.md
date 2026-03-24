---
name: blueprint-sync
description: Atualiza blueprints.md para refletir a estrutura atual do repositorio
compatibility: opencode
---

## Objetivo

Sincronizar `blueprints.md` com a estrutura real do codigo sem inventar arquitetura.

## Quando usar

- Mudancas estruturais recentes (pastas, modulos, responsabilidades).
- Divergencia percebida entre codigo atual e `blueprints.md`.
- Antes de decisao arquitetural que depende de documentacao atualizada.

## Regras

- Escopo: atualizar apenas `blueprints.md` com estado atual observavel.
- Nao escopo: analisar hotspots operacionais detalhados -> delegar para `repo-scan`.
- Nao escopo: validar violacoes arquiteturais em diff -> delegar para `architecture-guard`.
- Nao escopo: implementar ou refatorar codigo -> delegar para `feature-implement`.
- Arquivos permitidos: apenas `blueprints.md`.

### Criterios objetivos (Sim/Nao)

- [ ] Nao altera arquivos fora de `blueprints.md`.
- [ ] `blueprints.md` descreve apenas elementos existentes no repositorio.
- [ ] Inclui responsabilidades por pasta/modulo principais.
- [ ] Inclui invariantes arquiteturais ativos ou declara `Invariantes nao definidos`.
- [ ] Se nao houver divergencia, retorna explicitamente `Blueprint ja sincronizado`.

## Input esperado

- Estrutura atual do repositorio.
- Conteudo atual de `blueprints.md`.
- Decisoes arquiteturais vigentes, se existirem.

## Output esperado

- `blueprints.md` atualizado e consistente com o codigo atual.
- Lista curta das secoes ajustadas.
