---
name: qa-review
description: Revisão de qualidade completa antes do merge
compatibility: opencode
---

## Objetivo

Garantir que o código atenda a padrões de alta qualidade antes de ser mergeado ou executado.

## Quando usar

- Ao revisar pull requests ou code changes.
- Antes de mergear código novo ou modificado.
- Ao revisar código gerado automaticamente.
- Após correções de bugs para validação final.

## Regras

- Escopo: revisão completa de qualidade focando em: corretude, manutenibilidade, testabilidade, segurança, performance e clareza.
- Não escopo: correção automática de código -> delegar para `apply-audit-fixes`.
- Não escopo: análise profunda de bugs específicos -> delegar para `code_debug`.
- Não escopo: verificação de violações arquiteturais -> delegar para `architecture-guard`.
- Não escopo: auditoria de bugs e edge cases -> delegar para `audit-code`.
- Arquivos permitidos: nenhum (apenas leitura e revisão).

### Critérios objetivos (Sim/Não)

- [ ] Verifica corretude: lógica, edge cases, null handling, race conditions.
- [ ] Avalia qualidade do código: naming, tamanho de funções, separation of concerns.
- [ ] Confere cobertura de testes: lógica crítica, edge cases, determinismo.
- [ ] Valida error handling: propagação adequada, mensagens claras, sem falhas silenciosas.
- [ ] Inspeciona segurança: injeções, eval inseguro, input não validado, secrets.
- [ ] Analisa performance: loops desnecessários, I/O redundante, N+1 patterns.
- [ ] Confere logging e observabilidade: logs úteis, capacidade de debug.
- [ ] Entrega feedback estruturado com categorias definidas.
- [ ] Não modifica nenhum arquivo do repositório.

## Input esperado

- Diff, branch ou lista de arquivos a revisar.
- Contexto da mudança (feature/bug/refatoração).
- Requisitos de qualidade específicos, se existirem.

## Output esperado

- **Critical Issues**: Bugs, vulnerabilidades de segurança, race conditions.
- **Improvements**: Sugestões de melhorias claras e objetivas.
- **Suggested Refactors**: Oportunidades de refatoração com benefícios.
- **Missing Tests**: Áreas sem cobertura de testes identificadas.
- **Overall Assessment**: Avaliação geral da qualidade e recomendação de merge (Aprovado / Aprovado com ressalvas / Reprovado).

### Formato de saída

Para cada item identificado, incluir:
- **Localização**: arquivo:linha ou símbolo
- **Severidade**: Critical | High | Medium | Low
- **Descrição**: problema identificado
- **Sugestão**: correção ou melhoria proposta (com código quando aplicável)
