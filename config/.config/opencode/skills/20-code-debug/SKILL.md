---
name: 20-code-debug
description: Depura falhas concretas com validacao
compatibility: opencode
when_to_use: Quando ha erro reproduzivel, regressao, teste quebrado ou falha em execucao
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Reproduzir, isolar causa raiz, aplicar a menor correcao segura e validar.

## Quando usar

- Teste/comando falhando
- Stack trace ou erro em runtime
- Regressao apos mudanca recente
- Bug multi-arquivo sem causa obvia

## Escopo

**Faz:** reproduzir, diagnosticar e corrigir bug concreto.

**Nao faz:**
- Feature nova -> `20-feature-implement`
- Simplificacao sem falha concreta -> `20-code-simplifier`
- Auditoria ampla de bugs/seguranca -> `40-audit-code`
- Revisao arquitetural ampla -> `40-architecture-guard`

## Workflow

1. Reproduzir o sintoma com comando/cenario
2. Isolar o trecho minimo com falha
3. Formular hipotese de causa raiz com evidencia
4. Corrigir com patch minimo
5. Revalidar comando/teste afetado

## Criterios objetivos

- [ ] Sintoma foi reproduzido (ou limitacao explicada)
- [ ] Causa raiz foi identificada com evidencia
- [ ] Mudanca foi minima e focada
- [ ] Houve validacao apos correcao

## Input esperado

- Erro, stack trace, teste/comando que falha
- Arquivos/area suspeita (opcional)

## Output esperado

- Sintoma
- Causa raiz
- Correcao aplicada
- Validacao executada
- Risco residual

## Notes

- Priorize evidencia sobre suposicao.
- Evite refatoracao oportunista fora do bug.
