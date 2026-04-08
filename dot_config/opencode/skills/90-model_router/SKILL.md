---
name: 90-model_router
description: Roteia tarefas para modelos corretos
compatibility: opencode
when_to_use: Before executing any complex task or when uncertain which skill to apply
allowed-tools: ["Read", "Glob", "Bash", "skill"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Route tasks to the most appropriate agent and supporting skill based on the type of work.

## When to use

- Before executing any complex task
- When uncertain which skill to apply
- To ensure efficient resource usage (appropriate model selection)

## Rules

- Always load repository memory files before routing
- If memory/ is outdated, call skill: repo_analysis mode: memory first
- Choose the simplest safe path
- Delegate to the correct specialized agent first
- Use skills as support, not as a second competing architecture
- Never execute medium or large tasks directly - only route

### Routing Criteria

**planner-gpt** (`openai/gpt-5.3-codex`):
- Understanding repository structure
- Planning architecture
- Creating feature plans
- Breaking work into steps
- Identifying risks and trade-offs
- Pre-implementation review

Supporting skills when useful:
- `10-repo_analysis`
- `40-architecture-guard`

**ui-glm** (`opencode-go/minimax-m2.5` fallback until a dedicated GLM model is configured):
- Exploring UI directions
- Generating layout alternatives
- Suggesting screen structure
- Comparing visual approaches

**executor** (`openai/gpt-5.3-codex`):
- Writing code
- Editing functions
- Implementing planned features
- Generating tests
- Applying targeted fixes

Supporting skills when useful:
- `20-feature-implement`
- `20-code_debug`
- `20-code-simplifier`
- `30-test-*`
- `50-apply-audit-fixes`

**auditor-gpt** (`openai/gpt-5.3-codex`):
- Final review
- Edge case review
- Maintenance risk review
- Architecture or quality verification
- Difficult bug scrutiny without implementation

Supporting skills when useful:
- `40-audit-code`
 - `40-qa-review`
- `40-architecture-guard`
- `90-parallel`

### Objective Criteria (Yes/No)

- [ ] Loaded memory files (repo_summary.md, architecture.md, recent_changes.md)
- [ ] Analyzed task type correctly
- [ ] Selected appropriate agent and supporting skill
- [ ] Delegated task to chosen agent
- [ ] Did not modify files directly (only routed)

## Expected Input

- Description of the task to execute
- Optional context about the repository
- Loaded memory files (if they exist)

## Expected Output

- Recommended agent identification (`planner-gpt`, `ui-glm`, `executor`, or `auditor-gpt`)
- Optional supporting skill when it sharpens execution
- Task forwarding with preserved context

## Execution Flow

1. Check if memory/ exists and is up to date
   - If missing or outdated -> call skill: repo_analysis mode: memory when documentation refresh is needed

2. Analyze the task:
   - Understanding, planning, architecture, repo analysis -> `planner-gpt`
   - UI, screen UX, layout variations, component structure -> `ui-glm`
   - Writing, editing, fixing, testing, applying a plan -> `executor`
   - Final review, audit, edge cases, maintenance risk -> `auditor-gpt`

3. Add a supporting skill only when it reduces ambiguity or execution cost

4. Forward to the selected agent with:
   - The same original input
   - Complete repository context
   - The smallest necessary handoff

## Notes

- This skill should never execute code directly
- Keep the router thin: classify, delegate, stop
- Prefer planner before executor when scope is medium or large
- Preserve all context when delegating
