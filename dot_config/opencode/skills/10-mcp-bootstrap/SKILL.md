---
name: 10-mcp-bootstrap
description: Configura MCP por projeto no OpenCode com filesystem, git e memory
compatibility: opencode
when_to_use: When starting work on a new repository or need to configure MCP servers
allowed-tools: ["Read", "Glob", "Write", "Edit", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Preparar o repositório atual para uso com MCP no OpenCode, de forma simples, segura e reutilizável.

## When to use

- Starting work on a new repository
- When `.opencode/opencode.json` doesn't exist
- When MCP configuration is missing or incomplete
- Before using filesystem, git, or memory features
- Setting up a project for OpenCode with MCP

## Regras

- Nunca usar caminhos absolutos
- Sempre usar "." como raiz do projeto
- Não remover configurações existentes sem necessidade
- Não modificar código da aplicação
- Fazer mudanças mínimas
- Manter configuração legível

## Passos

1. Verificar se existe `.opencode/`
2. Verificar se existe `.opencode/opencode.json`

3. Se não existir:
   - criar `.opencode/opencode.json`

4. Se existir:
   - preservar conteúdo atual
   - adicionar apenas o necessário

## Configuração MCP

Garantir a existência deste bloco (sem duplicação):

{
  "mcp": {
    "filesystem": {
      "type": "local",
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "."
      ],
      "enabled": true
    },
    "git": {
      "type": "local",
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-git"
      ],
      "enabled": true
    },
    "memory": {
      "type": "local",
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-memory"
      ],
      "enabled": false
    }
  }
}

## Documentação

- Se existir README ou AGENTS.md:
  - adicionar seção curta sobre MCP

- Se não existir documentação adequada:
  - criar `.opencode/MCP.md` explicando:
    - o que é MCP no projeto
    - por que usar "."
    - por que memory começa desabilitado

## Output esperado

- lista de arquivos criados
- lista de arquivos modificados
- resumo das alterações
- instruções simples de validação

## Validação

O usuário deve conseguir:

- abrir o projeto no OpenCode
- pedir leitura de arquivos
- pedir git diff
