# Per-request steps budget (ExecutionContext)

Este repositório não contém o runner oficial de execução do OpenCode, então foi adicionada uma implementação local de referência para integração.

## O que foi implementado

- `ExecutionContext` em `src/runner/execution-context.js`
  - orçamento por requisição (não persiste entre mensagens)
  - prioridade de budget:
    1. `request.metadata.agentSteps` (limitado por cap)
    2. `agentConfig.steps`
    3. default `50`
  - cap global: `config.agent.maxStepsCap` (default `1000`)
  - `tryConsume(cost = 1, opName?)`
  - suporte a `operationCosts` (ex.: `{"git.merge": 3}`)
  - `budgetExhausted` quando não há budget

- Runner de referência em `src/runner/agent-runner.js`
  - bloqueia mutações quando orçamento esgota
  - injeta prompt de aviso em PT-BR e força modo texto-only no próximo turno

- Wrappers de mutação em `src/tools/mutation-tools.js`
  - `writeFile`, `gitCommit`, `gitMerge`, `spawnSubagent`, `execShell`, `networkMutatingCall`
  - todas checam budget antes de executar

## Prompt de orçamento esgotado

Quando `tryConsume` falha, o runner injeta:

`AVISO: o limite máximo de ações permitidas nesta execução foi atingido. Pare de executar ações que modificam o workspace. Responda apenas com texto contendo: 1) um resumo conciso do que você já fez (arquivos/commits); 2) lista priorizada de tarefas restantes; 3) comandos exatos/passos para continuar; 4) estimativa de passos adicionais necessários, se possível. Não tente executar mais ações automáticas.`

## Campo legado

- `agentConfig.maxSteps` é considerado **legado** e ignorado.
- Se detectado, é emitido warning: usar `agentConfig.steps`.

## Onde integrar manualmente no runtime real

Como o loop oficial não está neste repo, integrar nos pontos equivalentes do runtime externo:

1. **Entrada por mensagem do usuário**
   - criar novo `ExecutionContext` para cada request
2. **Loop principal do runner**
   - passar `ExecutionContext` para handlers de ferramentas e subagentes
3. **Handlers de mutação**
   - chamar `tryConsume` antes de executar mutação
4. **Falha de budget**
   - não executar ação
   - inserir prompt de aviso no próximo turno
   - forçar resposta texto-only
