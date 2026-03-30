---
name: audit-code
description: Audita código para bugs, edge cases e riscos
compatibility: opencode
---

## Objetivo

Auditar mudancas de codigo e reportar achados acionaveis sem modificar arquivos.

## Quando usar

- Apos implementacao de feature.
- Apos correcao de bug.
- Antes de aplicar correcoes com `apply-audit-fixes`.

## Regras

- Escopo: identificar bugs, riscos e inconsistencias relevantes no codigo alterado.
- Nao escopo: corrigir codigo -> delegar para `apply-audit-fixes`.
- Nao escopo: investigacao profunda de falha intermitente -> delegar para `surgical-debug`.
- Nao escopo: revisao de arquitetura ampla -> delegar para `architecture-guard`.
- Arquivos permitidos: nenhum.

### Criterios objetivos (Sim/Nao)

- [ ] Entrega tabela com colunas `Arquivo | Severidade | Problema | Sugestao`.
- [ ] Todo achado usa severidade valida: `Critico`, `Alto`, `Medio` ou `Baixo`.
- [ ] Todo achado aponta local verificavel (`arquivo:linha` ou simbolo unico).
- [ ] Nao modifica nenhum arquivo do repositorio.
- [ ] Se nao houver achados, retorna explicitamente `Sem achados`.

## Input esperado

- Diff, branch ou lista de arquivos alterados.
- Contexto curto da mudanca (feature/bug/refatoracao).
- Invariantes relevantes, se existirem.

## Output esperado

- Tabela de achados com severidade e sugestao objetiva.
- Lista final curta com total de achados por severidade.
