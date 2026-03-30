---
name: feature-implement
description: Implementa features novas
compatibility: opencode
---

## Objetivo

Implementar a menor solucao funcional para a feature solicitada sem quebrar invariantes.

## Quando usar

- Nova feature com escopo definido.
- Melhoria funcional de baixo a medio impacto.
- Correcao de comportamento quando nao ha relatorio de auditoria formal.

## Regras

- Escopo: implementar apenas o que foi solicitado no ticket/contexto.
- Nao escopo: corrigir backlog completo de auditoria -> delegar para `apply-audit-fixes`.
- Nao escopo: diagnostico profundo de bug intermitente -> delegar para `surgical-debug`.
- Nao escopo: atualizar documentacao estrutural -> delegar para `repo_analysis` ou `repo-docs`.
- Arquivos proibidos: `AGENTS.md`, `project.md`, `blueprints.md`, `architecture-decisions.md`, `current-state.md`.

### Criterios objetivos (Sim/Nao)

- [ ] Le os arquivos de contexto existentes entre `project.md`, `current-state.md`, `blueprints.md` e `architecture-decisions.md`.
- [ ] Nao altera arquivos de governanca.
- [ ] Se houver mudanca arquitetural, declara explicitamente antes de aplicar.
- [ ] Inclui teste para novo comportamento ou para bug corrigido quando houver suite de testes.
- [ ] Responde com: `O que mudou`, `Por que`, `Como testar`, `Limitacoes e proximos passos`.

## Input esperado

- Requisito funcional claro (ticket, prompt ou historia).
- Contexto do estado atual do modulo afetado.
- Restricoes tecnicas relevantes (performance, seguranca, compatibilidade).

## Output esperado

- Codigo implementado no menor escopo util.
- Testes e instrucoes objetivas de validacao.

## Modo execute

Quando ja existe um plano tecnico detalhado (plano de `repo_analysis` ou equivalente):
- Siga o plano exatamente.
- Modifique apenas arquivos necessarios.
- Produza patches minimos.
- Nao reescreva secoes grandes.
- Inclua teste se houver suite de testes.
