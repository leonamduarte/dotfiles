---
name: 30-quality-types
description: Valida tipagem TypeScript e cobertura de tipos
compatibility: opencode
when_to_use: Quando precisar medir robustez de tipos e identificar lacunas de tipagem
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Executar verificacao de tipos e apontar lacunas que aumentam risco de runtime.

## Quando usar

- Antes de merge/release em repos TS
- Apos migracoes JS -> TS
- Quando houver uso excessivo de `any`/`unknown` sem guardas

## Escopo

**Faz:** typecheck e analise estatica de cobertura de tipos.

**Nao faz:**
- Implementar correcoes amplas fora do escopo
- Auditoria funcional ampla -> `40-qa-review` ou `40-audit-code`

## Workflow

1. Detectar comando de typecheck do repo
2. Executar verificacao
3. Priorizar erros por impacto
4. Reportar como reproduzir e corrigir

## Criterios objetivos

- [ ] Comando de tipos executado
- [ ] Erros priorizados por impacto
- [ ] Reproducao documentada

## Input esperado

- Escopo alvo (opcional)
- Threshold/meta de tipagem (opcional)

## Output esperado

- Comando usado
- Principais falhas de tipo
- Proximos passos recomendados

## Notes

- Esta skill e de analise estatica, nao de implementacao.
