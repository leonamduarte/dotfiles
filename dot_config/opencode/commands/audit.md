---
description: Run the review-first auditor on the current task or repository scope.
agent: auditor
subtask: true
---

Review the current request or the directly relevant repository scope.

Expected behavior:
- always perform the technical audit
- include merge-readiness review only when the request calls for it
- do not edit files unless the user explicitly asks to apply narrow audit fixes
