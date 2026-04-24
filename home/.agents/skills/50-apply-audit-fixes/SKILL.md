---
name: 50-apply-audit-fixes
description: Aplica correcoes objetivas dos achados de auditoria
---

## Objective

Fix only the findings reported by audit, in severity order.

## When to use

- After `40-audit-code`
- Before another audit pass
- When the scope is a concrete list of findings

## Scope

Does:

- Apply targeted fixes
- Validate each fix

Does not:

- Search for unrelated new issues
- Redesign architecture
- Add new features outside the findings

## Workflow

1. Order findings by severity
2. Fix with the minimum patch
3. Validate each fix
4. Report resolved and pending items
