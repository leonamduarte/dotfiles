# Skill: model_router

Goal:
Route tasks to the correct model and skill.

Pre-execution rule:

Before executing any task, always load repository memory files:

memory/repo_summary.md  
memory/architecture.md  
memory/recent_changes.md

If the memory files do not exist or are outdated, call:

skill: repo_memory

Routing rules:

If the task involves:

- understanding repository structure
- reading many files
- planning architecture
- creating feature plans
- generating implementation steps

Use:

model: minimax-m2.7
reasoning: xhigh
skill: repo_analysis

If the task involves:

- writing code
- editing functions
- implementing a planned feature
- generating tests

Use:

model: codex-5.4-mini
reasoning: medium
skill: code_execute

If the task involves:

- debugging failing code
- fixing tests
- refactoring complex logic
- resolving multi-file bugs

Use:

model: codex-5.3
reasoning: high
skill: code_debug

Execution policy:

1. Analyze the task.
2. Select the correct skill.
3. Forward the task.
4. Escalate to Codex 5.3 only if needed.
