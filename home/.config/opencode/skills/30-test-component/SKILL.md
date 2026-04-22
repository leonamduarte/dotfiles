---
name: 30-test-component
description: Testa componentes React Native com Testing Library
compatibility: opencode
when_to_use: Para validar renderizacao e interacao de componentes RN sem emulador
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Criar testes de componente focados no comportamento visivel ao usuario.

## Quando usar

- Renderizacao condicional
- Interacoes (press/input)
- Estados de loading/erro/vazio
- Acessibilidade (labels/testID)

## Escopo

**Faz:** testes de UI de componente isolado (RNTL).

**Nao faz:**
- Fluxo entre varias camadas com servicos -> `30-test-jest-integration`
- Jornada E2E real -> `30-test-e2e-maestro`

## Workflow

1. Mapear props, eventos e estados
2. Escrever testes de render + interacao
3. Executar arquivo/suite alvo
4. Reportar resultado e cobertura funcional

## Criterios objetivos

- [ ] Estados principais cobertos
- [ ] Interacao critica coberta
- [ ] Comando de teste executado

## Input esperado

- Componente alvo
- Comportamentos esperados

## Output esperado

- Testes de componente criados/ajustados
- Resultado de execucao

## Notes

- Prefira assertions orientadas ao usuario final.
