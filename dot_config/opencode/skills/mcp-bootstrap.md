---
name: mcp-bootstrap
description: Configura MCP por projeto no OpenCode com filesystem, git e memory
compatibility: opencode
when_to_use: Ao iniciar ou padronizar um repositório para uso com MCP
allowed-tools: ["Read", "Glob", "Write", "Edit", "List", "Bash"]
model: inherit
user-invocable: true
context: inline
---

# Objetivo

Preparar o repositório atual para uso com MCP no OpenCode, de forma simples, segura e reutilizável.

# Contexto

- MCP por projeto, não globalmente
- Setup para projetos locais em desenvolvimento
- Foco inicial: filesystem, git, memory (preparado mas desabilitado)
- Filesystem restrito à raiz do projeto usando "."
- Sem hardcode de caminhos absolutos
- Solução fácil de copiar para outros repositórios

# Regras

- Nunca usar caminhos absolutos
- Sempre usar "." como raiz do projeto
- Não remover configurações existentes sem necessidade
- Não modificar código da aplicação
- Fazer mudanças mínimas
- Manter configuração legível

# Passos

1. Verificar se existe `.opencode/`
2. Verificar se existe `.opencode/opencode.json`

3. Se não existir:
   - criar `.opencode/opencode.json` com $schema e bloco MCP

4. Se existir:
   - preservar conteúdo atual
   - adicionar/atualizar apenas o bloco MCP necessário
   - não duplicar configurações

# Configuração MCP

```json
{
  "$schema": "https://opencode.ai/config.json",
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
```

# Documentação

- Se existir README, AGENTS.md, CLAUDE.md ou similar:
  - Adicionar seção curta explicando MCP configurado
  - Não reescrever tudo

- Se não existir documentação adequada:
  - Criar `.opencode/MCP.md` curto explicando:
    - O que foi configurado
    - Por que filesystem usa "."
    - Por que memory começa desabilitado
    - Como habilitar no futuro

# Critérios Objetivos (Sim/Não)

- [ ] Verificou estrutura atual do repositório
- [ ] Criou ou atualizou `.opencode/opencode.json`
- [ ] Adicionou $schema se não existia
- [ ] Configurou filesystem com args usando "."
- [ ] Configurou git com npx e server-git
- [ ] Configurou memory com enabled: false
- [ ] Preservou configurações existentes
- [ ] Não usou caminhos absolutos
- [ ] Adicionou documentação curta se necessário

# Input Esperado

- Repositório atual (diretório de trabalho)
- Contexto sobre qual projeto configurar

# Output Esperado

- Lista de arquivos criados
- Lista de arquivos alterados
- Diff resumido das alterações
- Instruções curtas de validação manual

# Validação Esperada

- Usuário consegue abrir o projeto no OpenCode
- Usuário consegue fazer leitura de arquivos
- Usuário consegue fazer git diff
- Memory pode ser habilitado no futuro mudando enabled: false para true

# Notas

- Não instalar dependências globalmente
- Não mexer em package.json, go.mod, CI/pipelines
- Preferir patch pequeno e seguro
- Se houver conflito com config existente, preservar config do projeto