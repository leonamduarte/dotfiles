---
name: test
description: "Define e executa validação útil: testes, lint, typecheck, cobertura ou TDD."
---

## Objective

Validate behavior with the smallest test surface that gives enough confidence.

## Use for

- TDD for bugs or features
- Choosing between unit, integration, component, or E2E coverage
- Running focused test commands
- Running lint or typecheck as validation steps

## Does

- Prefer behavior over implementation detail
- Choose the lightest credible validation
- Run targeted checks before broad suites when possible
- Report what passed, failed, and what remains unverified

## Does not

- Replace implementation work
- Act as final merge recommendation
- Expand tests just for symmetry

## Workflow

1. Identify the behavior that matters
2. Choose the smallest useful validation level
3. Add or run focused tests and checks
4. Prefer vertical slices over horizontal bulk test writing
5. Report confidence, gaps, and reproducible commands
