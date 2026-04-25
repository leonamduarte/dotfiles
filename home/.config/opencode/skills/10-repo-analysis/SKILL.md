---
name: 10-repo-analysis
description: Mapear repositorio e gerar analise ou plano
---

## Objective

Map the repository structure and produce either supporting analysis or an executable technical plan.

## When to use

- Starting work in an unknown repository
- There is not enough context to implement safely
- A plan is needed before changing multiple files

## Scope

Does:

- Read relevant structure, modules, and dependencies
- Identify hotspots, risks, and invariants
- Produce a scan-style analysis or a plan

Does not:

- Implement code
- Audit bugs or security
- Review merge readiness

## Workflow

1. Read governance context when it exists
2. Map only the relevant scope
3. Produce the requested output mode
4. Record risks and next steps clearly

## Output

- Scan: structure, hotspots, risks, and invariants
- Plan: technical plan with files, changes, and risks
