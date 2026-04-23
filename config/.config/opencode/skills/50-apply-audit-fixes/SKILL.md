---
name: 50-apply-audit-fixes
description: Aplica correcoes objetivas dos achados de auditoria
compatibility: opencode
when_to_use: Apos auditoria com achados priorizados por severidade
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Corrigir apenas os achados reportados, na ordem de severidade.

## Quando usar

- Depois de `40-audit-code`
- Antes de nova rodada de auditoria
- Com lista objetiva de achados

## Escopo

**Faz:** aplicar correcoes pontuais e validar.

**Nao faz:**
- Encontrar novos problemas amplos -> `40-audit-code`
- Redefinir arquitetura -> `40-architecture-guard`
- Feature nova fora dos achados -> `20-feature-implement`
- Investigacao profunda de falha nova -> `20-code-debug`

## Workflow

1. Ordenar achados por severidade
2. Corrigir com patch minimo
3. Validar cada correcao com comando/teste objetivo
4. Reportar resolvidos e pendentes

## Criterios objetivos

- [ ] Ordem: Critico > Alto > Medio > Baixo
- [ ] Cada correcao referencia achado de origem
- [ ] Sem feature/refatoracao fora do escopo
- [ ] Validacao executada
- [ ] Lista de resolvidos e pendentes

## Input esperado

- Relatorio de auditoria
- Diff/branch atual
- Restricoes de escopo

## Output esperado

- Correcoes aplicadas por prioridade
- Relatorio curto: `Resolvidos`, `Pendentes`, `Como validar`

## Notes

- Se surgir problema novo fora do achado, sinalize e nao amplie escopo sozinho.
