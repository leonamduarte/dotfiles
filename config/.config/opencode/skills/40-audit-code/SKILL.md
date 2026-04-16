---
name: 40-audit-code
description: Audita bugs, seguranca e edge cases
compatibility: opencode
when_to_use: Quando precisar encontrar riscos tecnicos reais antes de merge ou apos mudancas sensiveis
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Encontrar falhas de corretude e seguranca com foco em impacto real.

## Quando usar

- Pos-implementacao para captura de bugs
- Revisao de seguranca
- Validacao de edge cases antes de merge

## Escopo

**Faz:**
- Bugs logicos e regressao
- Vulnerabilidades e validacao de input
- Edge cases, null/undefined, concorrencia

**Nao faz:**
- Estilo/refatoracao -> `20-code-simplifier`
- Revisao de processo/merge readiness -> `40-qa-review`
- Revisao arquitetural -> `40-architecture-guard`

## Workflow

1. Ler diff/escopo
2. Procurar riscos tecnicos de maior impacto
3. Reportar com severidade e local exato
4. Declarar explicitamente quando nao houver achados

## Criterios objetivos

- [ ] Achados com local exato
- [ ] Severidade definida
- [ ] Foco em bugs/seguranca/edge cases
- [ ] Nao modifica arquivos

## Input esperado

- Diff/branch/arquivos
- Contexto funcional da mudanca

## Output esperado

- Tabela: arquivo, severidade, tipo, descricao, local
- Resumo por severidade

## Notes

- Priorize sinais comprovaveis sobre hipotese ampla.
