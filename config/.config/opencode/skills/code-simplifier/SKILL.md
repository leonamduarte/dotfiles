---
name: code-simplifier
description: Refina código para clareza e manutenção sem alterar comportamento
compatibility: opencode
---

## Objetivo

Simplificar código para maior legibilidade e manutenibilidade, preservando exatamente o comportamento atual.

## Quando usar

- Código confuso que precisa de refatoração para clareza.
- Após implementação de features (refinamento pós-código novo).
- Código legado difícil de manter.

## Regras

- Escopo: simplificar o código indicado preservando comportamento.
- Não escopo: diagnóstico de bugs -> delegar para `code_debug`.
- Não escopo: correção de violations arquiteturais -> delegar para `architecture-guard`.
- Não escopo: implementação de novas features -> delegar para `feature-implement`.

### Criterios objetivos (Sim/Nao)

- [ ] Preserva comportamento exato do código.
- [ ] Não altera regras de negócio, interfaces ou retornos.
- [ ] Adiciona comentários apenas quando necessário para explicação.
- [ ] Valida comportamento com testes se disponíveis.
- [ ] Segue padrões e convenções do projeto.

## Input esperado

- Arquivo(s) ou função(ões) a simplificar.
- Contexto do projeto (convenções, AGENTS.md ou CLAUDE.md).

## Output esperado

- Código simplificado.
- Resumo breve: o que foi simplificado e por quê.