---
name: 40-architecture-guard
description: Valida arquitetura e invariantes
compatibility: opencode
when_to_use: Quando houver mudanca estrutural, risco de acoplamento ou duvida sobre invariantes
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Detectar violacoes arquiteturais e quebra de invariantes com evidencias objetivas.

## Quando usar

- Antes de merge de mudancas estruturais
- Apos refatoracao com impacto entre camadas
- Quando houver suspeita de dependencia proibida

## Escopo

**Faz:** revisao arquitetural e de invariantes.

**Nao faz:**
- Corrigir codigo -> `50-apply-audit-fixes` ou `20-feature-implement`
- Auditoria funcional ampla -> `40-audit-code`
- Mapeamento geral de repositorio -> `10-repo-analysis`

## Workflow

1. Ler regras arquiteturais existentes
2. Inspecionar diff/arquivos afetados
3. Apontar violacoes com local e severidade
4. Listar invariantes preservados e quebrados

## Criterios objetivos

- [ ] Achados com `arquivo:linha` ou simbolo unico
- [ ] Severidade definida
- [ ] Nao modifica arquivos
- [ ] Se nada encontrar, retorna `Sem violacoes arquiteturais`

## Input esperado

- Diff ou lista de arquivos alterados
- Regras de arquitetura/invariantes

## Output esperado

- Tabela de violacoes
- Resumo de invariantes validados/quebrados

## Notes

- Seja estrito em evidencias, nao em opinioes.
