---
name: 30-test-jest-integration
description: Gera e executa testes de integracao com Jest
---

## Objective

Create and run integration tests for flows that cross module or layer boundaries.

## When to use

- Behavior depends on more than one unit
- A service boundary or module interaction changed

## Scope

Does:

- Cover module interactions
- Validate integration boundaries

Does not:

- Replace unit tests for pure logic
- Replace E2E UI coverage

## Workflow

1. Identify the interaction boundary
2. Add the smallest valuable integration cases
3. Run the relevant Jest command
4. Report results and coverage gaps
