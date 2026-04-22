---
name: 40-qa-review
description: Revisa qualidade e prontidao para merge
compatibility: opencode
when_to_use: Antes de merge/release para avaliar testes, docs, observabilidade e riscos operacionais
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Avaliar prontidao para merge com foco em qualidade de entrega e processo.

## Quando usar

- Revisao final de PR
- Validacao de Definition of Done
- Preparacao para release

## Escopo

**Faz:**
- Cobertura e qualidade de testes
- Documentacao e clareza operacional
- Tratamento de erro, logs e observabilidade
- Recomendacao final de merge

**Nao faz:**
- Bug/security hunting profundo -> `40-audit-code`
- Correcao de codigo -> `50-apply-audit-fixes` ou `20-feature-implement`
- Analise arquitetural profunda -> `40-architecture-guard`

## Workflow

1. Revisar diff e contexto de entrega
2. Avaliar categorias de qualidade
3. Apontar bloqueios e condicoes
4. Emitir recomendacao: `Aprovado`, `Aprovado com condicoes` ou `Nao pronto`

## Criterios objetivos

- [ ] Cobertura/gaps de testes reportados
- [ ] Docs e observabilidade avaliados
- [ ] Recomendacao de merge explicita
- [ ] Nao modifica arquivos

## Input esperado

- Diff/branch/arquivos
- Criterios de qualidade do time (se houver)

## Output esperado

- Relatorio por categoria
- Recomendacao final de merge

## Notes

- Esta skill complementa `40-audit-code`; use ambas em mudancas importantes.
