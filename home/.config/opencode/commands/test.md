---
description: Run the stack-aware tester on the current repository or request.
agent: tester
subtask: true
---

Validate the current repository or the directly relevant request scope.

Expected behavior:
- detect the stack first
- choose the smallest relevant skills or native test commands
- report failures, missing coverage, and the next safe validation step
