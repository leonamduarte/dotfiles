---
description: Run security review on current repository scope (loop-compatible).
agent: auditor
subtask: false
---

Execute revisão de segurança no escopo atual.

ESCOPO:
- Injeção de comando, path traversal, segredos em código.
- Dependências vulneráveis (npm audit, cargo audit, etc).
- Validação de input ausente.

REGRAS:
- Não editar arquivos.
- Não criar arquivos.
- Não rodar comandos destrutivos.

SAÍDA:
- Vulnerabilidades encontradas por severidade.
- Comandos de verificação executados e seus resultados.
