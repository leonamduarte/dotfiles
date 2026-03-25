# Skill: repo_memory

Goal:
Maintain persistent repository memory files.

Memory files:

memory/repo_summary.md
memory/architecture.md
memory/recent_changes.md

Instructions:

1. If memory files do not exist, create them.
2. Summarize repository purpose in repo_summary.md
3. Document architecture in architecture.md
4. Record important modifications in recent_changes.md
5. Update memory after major code changes.

Git safety rule:

The following files must never be committed:

memory/repo_summary.md
memory/architecture.md
memory/recent_changes.md

If these paths are missing in .gitignore, add:

memory/repo_summary.md
memory/architecture.md
memory/recent_changes.md
