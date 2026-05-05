---
description: Audit project dependencies for vulnerabilities and outdated packages (loop-compatible).
agent: auditor
subtask: false
---

Execute auditoria de dependências no repositório.

ESCOPO:
- Verificar package.json, Cargo.toml, go.mod, requirements.txt, etc.
- Rodar npm audit, cargo audit, pip-audit quando disponíveis.
- Identificar CVEs, deprecações, licenses restritivas.

REGRAS:
- Não editar arquivos.
- Não criar arquivos.
- Não sugerir atualizações sem evidência.

SAÍDA:
- Problemas encontrados por severidade.
- Versões afetadas e recomendações.
