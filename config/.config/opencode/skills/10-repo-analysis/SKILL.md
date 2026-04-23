---
name: 10-repo-analysis
description: Mapeia repositorio e gera analise/plano
compatibility: opencode
when_to_use: Quando precisar entender um repositorio ou montar plano de implementacao
allowed-tools: ["Read", "Glob", "Grep", "Write"]
model: inherit
user-invocable: true
context: inline
---

## Objetivo

Mapear a estrutura do repositorio e produzir documentacao de apoio (`analysis.md`) ou plano tecnico executavel.

## Quando usar

- Inicio de trabalho em repositorio desconhecido
- Falta de contexto para implementar com seguranca
- Necessidade de plano antes de mudar varios arquivos

## Escopo

**Faz:**

- Ler estrutura, modulos e dependencias relevantes
- Identificar hotspots, riscos e invariantes
- Gerar `analysis.md` (modo scan)
- Gerar plano tecnico (modo plan)
- adiciona todo e qualquer .md (que não seja o README.md) ao gitignore para que não seja versionado

**Nao faz:**

- Implementar codigo -> `20-feature-implement`
- Auditar bugs/seguranca -> `40-audit-code`
- Revisao de merge readiness -> `40-qa-review`

## Workflow

1. Ler contexto de governanca quando existir
2. Mapear apenas o escopo relevante
3. Produzir saida no modo pedido (`scan` ou `plan`)
4. Registrar riscos e proximos passos claros

## Criterios objetivos

- [ ] Escopo analisado esta claro
- [ ] Riscos e invariantes foram explicitados
- [ ] Saida segue o modo solicitado (`scan` ou `plan`)
- [ ] Nao houve alteracao de codigo de producao

## Input esperado

- Caminho/repositorio alvo
- Modo: `scan` ou `plan`
- Contexto funcional (quando houver)

## Output esperado

- **scan**: `analysis.md` com estrutura, hotspots, riscos e invariantes
- **plan**: plano tecnico com arquivos, mudancas e riscos

## Notes

- Mantenha analise objetiva e orientada a execucao.
- Se faltar contexto critico, liste perguntas curtas.
