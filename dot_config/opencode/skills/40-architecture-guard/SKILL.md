---
name: 40-architecture-guard
description: Valida arquitetura e invariantes do projeto
compatibility: opencode
---

## Objetivo

Detectar violacoes de arquitetura e invariantes para evitar degradacao estrutural.

## Quando usar

- Apos feature ou refatoracao com impacto em camadas.
- Antes de merge de mudancas estruturais.
- Quando houver suspeita de acoplamento indevido.

## Regras

- Escopo: validar dependencias entre camadas e invariantes arquiteturais.
- Nao escopo: corrigir codigo -> delegar para `50-apply-audit-fixes` ou `20-feature-implement`.
- Nao escopo: auditoria funcional geral -> delegar para `40-audit-code`.
- Nao escopo: mapeamento completo do repositorio -> delegar para `10-repo_analysis`.
- Arquivos permitidos: nenhum.

### Criterios objetivos (Sim/Nao)

- [ ] Todo achado referencia `arquivo:linha` ou simbolo unico.
- [ ] Todo achado indica dependencia proibida ou invariante quebrado.
- [ ] Todo achado possui severidade: `Critico`, `Alto`, `Medio` ou `Baixo`.
- [ ] Nao modifica arquivos do repositorio.
- [ ] Se nao houver violacoes, retorna explicitamente `Sem violacoes arquiteturais`.

## Input esperado

- Diff ou lista de arquivos alterados.
- Regras de arquitetura documentadas (`blueprints.md`, `architecture-decisions.md`).
- Contexto de camadas/modulos, se necessario.

## Output esperado

- Tabela de violacoes com severidade e sugestao de ajuste.
- Lista curta de invariantes validados e invariantes quebrados.
