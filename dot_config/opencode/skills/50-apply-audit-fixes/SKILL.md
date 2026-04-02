---
name: apply-audit-fixes
description: Aplica correções de auditoria priorizadas
compatibility: opencode
---

## Objetivo

Aplicar correcoes objetivas para os achados do auditor, priorizando risco.

## Quando usar

- Apos execucao de `audit-code`.
- Quando existir lista de achados com severidade.
- Antes de nova rodada de auditoria.

## Regras

- Escopo: corrigir somente itens reportados no audit atual.
- Nao escopo: encontrar novos problemas amplos -> delegar para `audit-code`.
- Nao escopo: investigacao extensa de causa raiz fora do achado -> delegar para `surgical-debug`.
- Nao escopo: redefinir arquitetura -> delegar para `architecture-guard` + decisao explicita.
- Arquivos permitidos: apenas os necessarios para corrigir os achados.

### Criterios objetivos (Sim/Nao)

- [ ] Processa os achados em ordem de severidade: `Critico`, `Alto`, `Medio`, `Baixo`.
- [ ] Cada correcao referencia o achado de origem (`arquivo` + descricao curta).
- [ ] Nao implementa feature nova nem refatoracao fora do escopo dos achados.
- [ ] Executa validacao objetiva (teste/comando) para as correcoes aplicadas.
- [ ] Lista explicitamente achados resolvidos e pendentes.

## Input esperado

- Relatorio de auditoria com severidade e local.
- Diff ou branch com o estado atual.
- Restricoes de escopo definidas para a rodada.

## Output esperado

- Correcoes aplicadas por prioridade de severidade.
- Relatorio curto com `Resolvidos`, `Pendentes` e `Como validar`.
