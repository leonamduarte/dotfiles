---
name: mcp-bootstrap
description: Configura MCP servers no diretório .agents/ do repositório atual
---

## Objetivo

Criar e gerenciar a configuração de MCP servers no repositório atual,
dentro de `.agents/<tool>/`, sem alterar nada fora do projeto.

## Quando usar

- Um repositório novo precisa de MCP servers para Codex e/ou Gemini CLI
- Um repositório existente precisa de MCP servers adicionais

## Regras

- Use apenas caminhos relativos; nunca absolutos
- Use `.` como raiz do projeto quando um MCP server precisar de um path root
- Não modifique código de aplicação
- Se uma skill precisar de dependências MCP (npm), declare em `agents/openai.yaml`
- Adicione `.agents/` ao `.gitignore` do repositório

## Workflow

1. Verifique se `.agents/` já existe no repositório
2. Crie `.agents/<tool>/mcp.toml` com os MCP servers necessários
3. Crie `.agents/openai.yaml` se houver dependências npm a declarar
4. Adicione `.agents/` ao `.gitignore` se ainda não estiver lá

## Exemplo

```toml
# .agents/codex/mcp.toml
[mcp.servers.filesystem]
type = "stdio"
command = ["npx", "-y", "@modelcontextprotocol/server-filesystem", "."]
enabled = true
```

## Output

- Arquivos criados/modificados em `.agents/`
- Comando de validação
- Gaps restantes (se houver)

## Validação

- Confirme que `.agents/<tool>/mcp.toml` existe no repositório
- Confirme que `.agents/openai.yaml` existe (se declarou dependências)
- Confirme que `.agents/` está no `.gitignore`
