---
name: 20-code-simplifier
description: Simplifica codigo sem mudar comportamento
compatibility: opencode
when_to_use: Quando o codigo funciona, mas esta complexo, duplicado ou dificil de manter
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Reduzir complexidade acidental mantendo comportamento e contratos.

## Quando usar

- Funcoes grandes e confusas
- Duplicacao de logica
- Fluxo com nesting excessivo
- Nomes pouco claros

## Escopo

**Faz:** refatoracao segura e incremental.

**Nao faz:**
- Diagnostico de falha concreta -> `20-code-debug`
- Feature nova -> `20-feature-implement`
- Auditoria tecnica -> `40-audit-code`
- Redesenho arquitetural -> `40-architecture-guard`

## Workflow

1. Entender comportamento atual
2. Escolher simplificacoes de maior valor
3. Aplicar mudancas pequenas e revisaveis
4. Validar que comportamento foi preservado

## Criterios objetivos

- [ ] Nao alterou regra de negocio
- [ ] Reduziu complexidade em ponto claro
- [ ] Mudancas ficaram locais e revisaveis
- [ ] Validacao executada ou risco informado

## Input esperado

- Arquivo, funcao ou diff alvo
- Restricoes de estilo/arquitetura (se houver)

## Output esperado

- O que foi simplificado
- Por que ficou melhor
- Como foi validado
- Risco residual

## Notes

- Prefira remover complexidade em vez de criar abstração nova.
