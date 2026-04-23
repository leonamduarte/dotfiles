---
name: 30-test-jest-unit
description: Gera e executa testes unitarios com Jest
compatibility: opencode
when_to_use: Para validar funcoes puras e regras de negocio isoladas
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Criar e executar testes unitarios focados em comportamento observavel.

## Quando usar

- Helpers e utilitarios puros
- Regras de negocio sem IO
- Parsers e transformacoes de dados

## Escopo

**Faz:** criar/ajustar testes unitarios e executar comandos de teste relevantes.

**Nao faz:**
- Fluxo entre camadas -> `30-test-jest-integration`
- E2E/UI real -> `30-test-e2e-maestro`

## Workflow

1. Identificar funcao/comportamento alvo
2. Escrever casos: happy path, edge cases e erro
3. Executar teste focado
4. Reportar resultado e gaps

## Criterios objetivos

- [ ] Casos essenciais cobertos
- [ ] Comando de teste executado
- [ ] Resultado e gaps reportados

## Input esperado

- Arquivo/funcoes alvo
- Regras esperadas

## Output esperado

- Testes criados/atualizados
- Resultado de execucao

## Notes

- Teste comportamento, nao detalhe interno de implementacao.
