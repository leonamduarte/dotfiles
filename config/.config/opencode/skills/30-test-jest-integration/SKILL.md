---
name: 30-test-jest-integration
description: Gera e executa testes de integracao com Jest
compatibility: opencode
when_to_use: Para validar fluxo entre modulos/camadas com dependencias mockadas
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Validar integracao entre componentes/modulos com cenarios de sucesso e falha.

## Quando usar

- Fluxo service -> API/repo
- Integracao entre modulos
- Tratamento de falhas externas com mocks

## Escopo

**Faz:** criar testes de integracao com mocks realistas e executar validacao.

**Nao faz:**
- Unidade pura -> `30-test-jest-unit`
- E2E em app/dispositivo -> `30-test-e2e-maestro`

## Workflow

1. Definir fluxo ponta a ponta em nivel de modulo
2. Configurar mocks necessarios
3. Escrever testes de sucesso e erro
4. Executar suite/arquivo afetado

## Criterios objetivos

- [ ] Fluxo principal e erro relevante cobertos
- [ ] Mocks e setup estao claros
- [ ] Comando de teste executado

## Input esperado

- Fluxo alvo
- Dependencias externas e cenario esperado

## Output esperado

- Testes de integracao criados/ajustados
- Resultado de execucao

## Notes

- Evite mocks irreais que escondem comportamento critico.
