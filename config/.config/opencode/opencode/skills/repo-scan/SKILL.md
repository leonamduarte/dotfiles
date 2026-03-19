---
name: repo-scan
description: Analisa o repositorio, identifica hotspots e atualiza analysis.md
compatibility: opencode
---

## Objetivo

Mapear a estrutura atual do repositorio e gerar `analysis.md` acionavel para execucao e auditoria.

## Quando usar

- Inicio de trabalho em repositorio desconhecido.
- Antes de planejar feature relevante.
- Quando `analysis.md` estiver ausente ou desatualizado.

## Regras

- Escopo: leitura estrutural do codigo e atualizacao de `analysis.md`.
- Nao escopo: implementar codigo -> delegar para `feature-implement`.
- Nao escopo: atualizar desenho alvo futuro -> delegar para `blueprint-sync`.
- Nao escopo: revisar conformidade arquitetural detalhada -> delegar para `architecture-guard`.
- Arquivos permitidos: apenas `analysis.md`.

### Criterios objetivos (Sim/Nao)

- [ ] Le os arquivos de contexto existentes entre `project.md`, `current-state.md`, `blueprints.md` e `architecture-decisions.md`.
- [ ] `analysis.md` contem secoes: `Overview`, `Structure`, `Hotspots`, `Risks`, `Invariants` e `Recommended Next Steps`.
- [ ] Lista ao menos 3 hotspots ou declara explicitamente `Sem hotspots relevantes`.
- [ ] Lista ao menos 2 invariantes ou declara explicitamente `Invariantes nao definidos`.
- [ ] Nao altera arquivos fora de `analysis.md`.

## Input esperado

- Caminho do repositorio alvo.
- Contexto de negocio/produto disponivel.
- Documentos de governanca existentes, se houver.

## Output esperado

- Arquivo `analysis.md` criado/atualizado com foco estrutural.
- Resumo curto dos principais hotspots e riscos.
