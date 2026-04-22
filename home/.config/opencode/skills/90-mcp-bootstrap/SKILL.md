---
name: mcp-bootstrap
description: Configura MCP por projeto no OpenCode com filesystem, git e memory
compatibility: opencode
---

## Objetivo

Preparar o repositório atual para uso com MCP no OpenCode, de forma simples, segura e reutilizável.

## Regras

- Nunca usar caminhos absolutos
- Sempre usar "." como raiz do projeto
- Não remover configurações existentes sem necessidade
- Não modificar código da aplicação
- Fazer mudanças mínimas
- Manter configuração legível
- O servidor `@cyanheads/git-mcp-server` é um pacote de terceiro — verificar se ainda é mantido antes de usar em projetos críticos

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

```json
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
        "@cyanheads/git-mcp-server@latest"
      ],
      "env": {
        "MCP_TRANSPORT_TYPE": "stdio",
        "MCP_LOG_LEVEL": "info"
      },
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
```

## Documentação

Se existir README ou AGENTS.md:

- adicionar seção curta sobre MCP com o seguinte conteúdo mínimo:
  - quais servidores estão ativos
  - que "." é usado como raiz
  - que memory está desabilitado por padrão e como habilitar (ver abaixo)

Se não existir documentação adequada:

- criar `.opencode/MCP.md` com:
  - o que é MCP no projeto
  - por que usar "."
  - por que memory começa desabilitado e quando habilitar:
    - habilitar memory quando o projeto tiver sessões longas ou contexto que precise persistir entre conversas
    - para habilitar: alterar `"enabled": false` para `"enabled": true` no bloco memory do opencode.json

## Output esperado

- lista de arquivos criados
- lista de arquivos modificados
- resumo das alterações
- instruções simples de validação

## Validação

O usuário deve conseguir:

1. Confirmar que os servidores subiram:
   - rodar `opencode mcp list` e verificar que `filesystem` e `git` aparecem como conectados
2. Testar filesystem:
   - pedir leitura de um arquivo do projeto
3. Testar git:
   - pedir um `git diff` ou `git log`
4. Confirmar que memory aparece na lista mas está desabilitado (não conectado)
