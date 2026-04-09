---
name: 90-model_router
description: Roteia tarefas para os agentes atuais
compatibility: opencode
when_to_use: Before executing any complex task or when uncertain which skill to apply
allowed-tools: ["Read", "Glob", "Bash", "skill"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Route tasks to the most appropriate current agent and supporting skill.

## Routing

**build**:
- Primary entrypoint and task triage

**planner** (`openai/gpt-5.4`):
- Planning, architecture, repository analysis
- Trade-offs, risks, implementation shape
- Read-only repo mapping and plan generation

Supporting skills:
- `10-repo_analysis`
- `40-architecture-guard`

**copilot-worker** (`opencode-go/minimax-m2.5`):
- Simple and medium local changes
- Small refactors
- Low-risk fixes
- Narrow debug work

Supporting skills:
- `20-feature-implement`
- `20-code_debug`
- `20-code-simplifier`

**implementer** (`openai/gpt-5.3-codex`):
- Writing code
- Editing functions
- Implementing planned features
- Applying targeted fixes
- Handling multi-file or higher-risk changes
- Investigating issues that need broader context
- Handling architecture questions, broad planning, or repository analysis when they require deeper context
- Owning requests that require both implementation and validation

Supporting skills:
- `20-feature-implement`
- `20-code_debug`
- `20-code-simplifier`

**tester** (`opencode-go/minimax-m2.5`):
- Running validation
- Choosing the narrowest useful test path
- Checking lint, types, unit, integration, component, and E2E coverage
- Validation-only work without implementation

Supporting skills:
- `30-test-*`

**auditor** (`openai/gpt-5.4`):
- Final review
- Edge case review
- Maintenance risk review
- Architecture or quality verification
- Difficult bug scrutiny without implementation

Supporting skills:
- `40-audit-code`
- `40-qa-review`
- `40-architecture-guard`
- `90-parallel`

## Notes

- Keep the router thin: classify, delegate, stop
- Use `copilot-worker` for simple and medium local work
- Use `implementer` for complex, multi-file, investigative, or fix-plus-validate work
- Use `planner` for planning, architecture, repository analysis, and trade-off work
- Use `tester` for validation-only work
