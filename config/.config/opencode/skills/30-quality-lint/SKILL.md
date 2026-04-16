---
name: 30-quality-lint
description: Executa lint e reporta problemas de qualidade
compatibility: opencode
when_to_use: Quando precisar validar padrao de codigo com ESLint antes de commit/merge
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Executar lint do projeto e reportar erros/warnings com comandos reproduziveis.

## Quando usar

- Pre-commit ou pre-merge
- Validacao de mudancas grandes
- Diagnostico de falhas de CI ligadas a lint

## Escopo

**Faz:** rodar lint existente, coletar resultado e indicar proximos passos.

**Nao faz:**
- Criar feature/refatoracao ampla
- Auditoria funcional/seguranca -> `40-audit-code`

## Workflow

1. Detectar comando de lint do repo
2. Executar comando mais especifico possivel
3. Separar erros de warnings
4. Reportar arquivos afetados e como reproduzir

## Criterios objetivos

- [ ] Comando de lint executado
- [ ] Resultado classificado (erro/warning)
- [ ] Reproducao documentada

## Input esperado

- Escopo de arquivos (opcional)
- Comando padrão do projeto (opcional)

## Output esperado

- Comando usado
- Resumo de erros/warnings
- Proximos passos objetivos

## Notes

- Esta skill e de analise estatica, nao de implementacao.
