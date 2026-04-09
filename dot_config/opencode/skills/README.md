# Advanced Skills for Opencode

This directory contains the active skill set used by the current OpenCode agent architecture.

## Current Runtime Layout

- `build`: cheap entrypoint that classifies and delegates once
- `copilot-worker`: low-cost execution for simple and medium local work
- `implementer`: heavy execution for complex, multi-file, investigative, or fix-plus-validate work
- `tester`: validation-only execution
- `auditor`: final technical audit and merge-readiness review

## Routing Policy

- Send simple, local, low-risk work to `copilot-worker`
- Send broad planning, architecture, repository analysis, debugging, behavior changes, or multi-file work to `implementer`
- Send validation-only requests to `tester`
- Send review, audit, risk review, and merge-readiness requests to `auditor`

Rule of thumb:

- If the task needs code changes and then validation, use `implementer`
- If the task only needs validation and should not edit files, use `tester`
- If the task is small and local, use `copilot-worker`
- If the task is review-first, use `auditor`

## Skill Boundaries

- `20-feature-implement`: implement a defined change
- `20-code_debug`: reproduce, isolate, and fix a concrete failure
- `20-code-simplifier`: behavior-preserving cleanup
- `30-test-*`: validation skills used by `tester`
- `40-audit-code`: correctness and safety review
- `40-qa-review`: readiness, test gaps, docs, and observability review
- `40-architecture-guard`: architecture drift and dependency checks
- `50-apply-audit-fixes`: narrow follow-up fixes to audit findings
- `90-model_router`: describes the routing policy
- `90-parallel`: parallel review or exploration when explicitly needed
- `90-fork`: isolated skill execution when needed

## Maintenance Notes

- Keep this README aligned with the real files in `agents/`, `commands/`, and `skills/`
- Prefer updating routing policy in one pass across the router skill and active prompts
- Treat `prompts/legacy/` in the dotfiles mirror as archived reference, not active runtime behavior
