---
name: 30-test-e2e-maestro
description: Gera e executa testes E2E com Maestro
compatibility: opencode
when_to_use: Para validar fluxos criticos completos em app React Native/Expo
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Automatizar fluxos E2E com Maestro para garantir comportamento em nivel de jornada.

## Quando usar

- Login, cadastro, compra e fluxos criticos
- Navegacao entre telas
- Smoke tests de release

## Escopo

**Faz:** criar flows YAML, executar e reportar falhas de fluxo.

**Nao faz:**
- Teste unitario/integracao de modulo -> `30-test-jest-unit` / `30-test-jest-integration`

## Workflow

1. Mapear jornada e checkpoints
2. Criar/atualizar flow Maestro (`flows/*.yaml`)
3. Executar fluxo(s)
4. Reportar passos que falharam e evidencias

## Criterios objetivos

- [ ] Fluxo critico coberto
- [ ] Execucao realizada
- [ ] Falhas e reproducoes descritas

## Input esperado

- Fluxo alvo
- testIDs/telas disponiveis

## Output esperado

- Flow(s) Maestro
- Resultado de execucao E2E

## Notes

- Use testIDs estaveis para reduzir flakiness.
