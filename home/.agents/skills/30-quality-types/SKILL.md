---
name: 30-quality-types
description: Valida tipagem TypeScript e cobertura de tipos
---

## Objective

Run type checking and report type coverage gaps that increase runtime risk.

## When to use

- Before merge or release in a TypeScript repo
- After JS to TS migrations
- When `any` or `unknown` is used without guards

## Scope

Does:

- Detect the repository typecheck command
- Run the verification
- Prioritize type errors by impact

Does not:

- Implement large corrective changes
- Do broad functional audits

## Workflow

1. Detect the typecheck command
2. Run it
3. Prioritize errors
4. Report how to reproduce and fix
