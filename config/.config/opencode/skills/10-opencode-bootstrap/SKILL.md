---
name: 10-opencode-bootstrap
description: Prepara um projeto OpenCode completo com config na raiz, router por projeto, comandos e estrutura local reutilizavel
compatibility: opencode
when_to_use: When starting a new repository or standardizing a project-specific OpenCode setup across machines
allowed-tools: ["Read", "Glob", "Write", "Edit", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Preparar o repositorio atual com uma estrutura OpenCode replicavel por projeto, usando `opencode.json` na raiz, `.opencode/agents/`, `.opencode/commands/` e `.opencode/skills/` quando necessario.

## Quando usar

- Ao iniciar um novo repositorio
- Ao padronizar o OpenCode entre maquinas
- Quando o projeto ainda usa `.opencode/opencode.json` em vez de `opencode.json` na raiz
- Quando faltam agentes por projeto, comandos recorrentes ou estrutura local clara
- Quando se quer reduzir dependencia de configuracao global opinativa

## Regras

- Sempre preferir `opencode.json` na raiz do projeto
- Usar `.opencode/` para `agents/`, `commands/`, `skills/` e `mcp/`
- Nao sobrescrever configuracoes existentes sem necessidade
- Preservar MCPs locais e comandos ja validos
- Fazer mudancas minimas e legiveis
- Se o projeto nao precisar de router custom, nao criar router
- Se o projeto precisar de fluxos repetitivos, preferir `commands/` a prompts longos no chat

### Criterios objetivos (Sim/Nao)

- [ ] Existe `opencode.json` na raiz do projeto
- [ ] Nao existe dependencia de `.opencode/opencode.json` fora do padrao documentado
- [ ] Agentes por projeto ficam em `.opencode/agents/` quando necessarios
- [ ] Comandos recorrentes ficam em `.opencode/commands/`
- [ ] MCP local continua funcional
- [ ] Mudancas ficaram replicaveis em dotfiles ou template compartilhado

## Input esperado

- Repositorio atual aberto no OpenCode
- Objetivo do setup local: com router ou sem router
- MCPs locais necessarios
- Fluxos recorrentes que merecem comandos dedicados

## Passos

1. Verificar se existe `opencode.json` na raiz do repositorio.
2. Se existir apenas `.opencode/opencode.json`, migrar para `opencode.json` na raiz preservando MCPs e chaves validas.
3. Criar `.opencode/agents/` apenas para agentes especificos do projeto.
4. Criar `.opencode/commands/` para fluxos recorrentes e sensiveis a contexto.
5. Reutilizar agentes globais em `~/.config/opencode/agents/` sempre que forem genericos.
6. Criar ou atualizar `.opencode/skills/` apenas para conhecimento realmente local do projeto.
7. Validar JSON e conferir descoberta dos arquivos esperados.
8. Se o usuario usa dotfiles, espelhar a estrutura relevante no repositorio de configuracao.

## Padrao recomendado

### 1. Config raiz do projeto

Criar `opencode.json` na raiz do repositorio com:

- `default_agent` apropriado ao projeto
- bloco `mcp` local
- apenas overrides especificos do projeto

### 2. Agentes por projeto

Usar `.opencode/agents/*.md` para:

- router por projeto
- agentes especializados por dominio
- agentes temporarios que nao fazem sentido globalmente

### 3. Commands por projeto

Usar `.opencode/commands/*.md` para:

- sincronizar blueprint
- iniciar fases recorrentes
- review de risco
- debug de API ou infra local

### 4. Skills por projeto

Usar `.opencode/skills/*.md` para:

- conhecimento de dominio local
- workflows de MCP locais
- restricoes especificas do repositorio

## Nao escopo

- Nao reescrever toda a estrategia global de agentes sem necessidade
- Nao alterar codigo da aplicacao como parte do bootstrap
- Nao instalar dependencias nao relacionadas ao OpenCode

## Output esperado

- Lista de arquivos criados
- Lista de arquivos modificados
- Resumo da estrutura final
- Comandos de validacao sugeridos
- Observacoes sobre o que ficou global e o que ficou por projeto
