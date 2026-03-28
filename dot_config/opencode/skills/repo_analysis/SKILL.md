---
name: repo_analysis
description: Mapeia repo, identifica hotspots e produz plano de implementação ou analysis.md
compatibility: opencode
---

## Objetivo

Analisar a estrutura do repositório e produzir um dos dois outputs:
- **Modo scan**: `analysis.md` com Overview, Structure, Hotspots, Risks, Invariants, Next Steps
- **Modo plan**: Plano de implementação com arquivos, módulos, mudanças e riscos

## Quando usar

- Inicio de trabalho em repositorio desconhecido.
- Antes de planejar feature relevante.
- Quando `analysis.md` estiver ausente ou desatualizado.
- Quando existe um plano tecnico que precisa ser implementado.

## Regras

- Escopo: leitura estrutural do codigo e producao de output documental ou plano.
- Nao escopo: implementar codigo -> delegar para `feature-implement`.
- Nao escopo: atualizar desenho alvo futuro -> delegar para `repo-docs`.
- Nao escopo: revisar conformidade arquitetural detalhada -> delegar para `architecture-guard`.
- Arquivos permitidos: apenas `analysis.md` (modo scan).

### Criterios objetivos — Modo scan (Sim/Nao)

- [ ] Le os arquivos de contexto existentes entre `project.md`, `current-state.md`, `blueprints.md` e `architecture-decisions.md`.
- [ ] `analysis.md` contem secoes: `Overview`, `Structure`, `Hotspots`, `Risks`, `Invariants` e `Recommended Next Steps`.
- [ ] Lista ao menos 3 hotspots ou declara explicitamente `Sem hotspots relevantes`.
- [ ] Lista ao menos 2 invariantes ou declara explicitamente `Invariantes nao definidos`.
- [ ] Nao altera arquivos fora de `analysis.md`.

### Criterios objetivos — Modo plan (Sim/Nao)

- [ ] Le os arquivos de contexto relevantes.
- [ ] Plano contem: Files to modify, New modules or functions, Required changes, Potential risks.
- [ ] Identifica pontos de implementacao claros.

## Input esperado

- Caminho do repositorio alvo.
- Contexto de negocio/produto disponivel.
- Documentos de governanca existentes, se houver.

## Output esperado

**Modo scan**: Arquivo `analysis.md` criado/atualizado com foco estrutural e resumo dos principais hotspots e riscos.

**Modo plan**: Plano estruturado:

PLAN

1. Files to modify
2. New modules or functions
3. Required changes
4. Potential risks

END PLAN
