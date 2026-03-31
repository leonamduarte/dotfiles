---
name: model_router
description: Route tasks to the correct model and skill
compatibility: opencode
when_to_use: Before executing any complex task or when uncertain which skill to apply
allowed-tools: ["Read", "Glob", "Bash", "skill"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Route tasks to the most appropriate model and skill based on the type of work.

## When to use

- Before executing any complex task
- When uncertain which skill to apply
- To ensure efficient resource usage (appropriate model selection)

## Rules

- Always load repository memory files before routing
- If memory/ is outdated, call skill: repo_analysis mode: memory first
- Choose model based on task complexity
- Delegate to the correct specialized skill
- Never execute tasks directly - only route

### Routing Criteria

**For analysis and planning (model: minimax-m2.7, reasoning: xhigh, skill: repo_analysis):**
- Understanding repository structure
- Reading many files
- Planning architecture
- Creating feature plans
- Generating implementation steps

**For code implementation (model: codex-5.4-mini, reasoning: medium, skill: feature-implement):**
- Writing code
- Editing functions
- Implementing planned features
- Generating tests

**For debugging (model: codex-5.3, reasoning: high, skill: code_debug):**
- Debugging failing code
- Fixing broken tests
- Refactoring complex logic
- Resolving multi-file bugs

### Objective Criteria (Yes/No)

- [ ] Loaded memory files (repo_summary.md, architecture.md, recent_changes.md)
- [ ] Analyzed task type correctly
- [ ] Selected appropriate model and skill
- [ ] Delegated task to chosen skill
- [ ] Did not modify files directly (only routed)

## Expected Input

- Description of the task to execute
- Optional context about the repository
- Loaded memory files (if they exist)

## Expected Output

- Recommended model identification (minimax-m2.7, codex-5.4-mini, or codex-5.3)
- Selected skill (repo_analysis, feature-implement, code_debug)
- Task forwarding with preserved context

## Execution Flow

1. Check if memory/ exists and is up to date
   - If missing or outdated → call skill: repo_analysis mode: memory

2. Analyze the task:
   - Is it about understanding/planning? → model: minimax-m2.7 + repo_analysis
   - Is it about writing/implementing? → model: codex-5.4-mini + feature-implement
   - Is it about debugging/fixing? → model: codex-5.3 + code_debug

3. Forward to selected skill with:
   - The same original input
   - Complete repository context
   - Appropriate model settings

## Notes

- This skill should never execute code directly
- Only escalate to codex-5.3 when necessary
- Preserve all context when delegating to other skills
