---
name: 20-feature-implement
description: Implementa features e melhorias funcionais
compatibility: opencode
when_to_use: Quando existe requisito funcional claro para implementar com escopo controlado
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Entregar a menor implementacao util para o requisito, com validacao proporcional ao risco.

## Quando usar

- Feature nova com escopo definido
- Melhoria funcional de baixo/medio impacto
- Correcao funcional pontual sem relatorio formal de auditoria

## Escopo

**Faz:** implementacao e ajustes funcionais no escopo pedido.

**Nao faz:**
- Backlog de achados de auditoria -> `50-apply-audit-fixes`
- Debug profundo de bug intermitente -> `20-code-debug`
- Mapeamento/documentacao estrutural -> `10-repo-analysis`

## Workflow

1. Ler contexto e padrao local
2. Implementar o menor slice completo
3. Evitar refatoracao paralela fora do escopo
4. Executar validacao objetiva
5. Reportar mudanca, motivo e teste

## Criterios objetivos

- [ ] Escopo pedido foi respeitado
- [ ] Arquivos de governanca nao foram alterados sem pedido
- [ ] Validacao executada ou lacuna explicitada
- [ ] Resposta inclui: `O que mudou`, `Por que`, `Como testar`

## Input esperado

- Requisito funcional/ticket
- Contexto tecnico relevante

## Output esperado

- Implementacao no menor escopo util
- Passos objetivos de validacao

## Notes

- Se houver impacto arquitetural, sinalize antes de ampliar escopo.
