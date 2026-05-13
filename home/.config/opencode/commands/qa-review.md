---
description: Run quality review on current repository scope (loop-compatible).
agent: tester
subtask: false
---

Execute revisão de qualidade no escopo atual.

ESCOPO:
- Rodar testes disponíveis (npm test, go test, cargo test, pytest).
- Verificar typecheck, lint, formatação.
- Avaliar cobertura e documentação.

REGRAS:
- Não editar arquivos.
- Não criar arquivos.
- Não implementar correções.

SAÍDA:
- Status de cada pilar de qualidade (✅/❌).
- Comandos executados e suas saídas.
- Recomendação final (merge ready?).
