---
name: 20-code-simplifier
description: Simplifica codigo sem mudar comportamento
compatibility: opencode
when_to_use: When code works but is harder to read, maintain, or extend than it needs to be
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Act as a refactor helper: identify the highest-value simplifications, remove unnecessary complexity, and preserve existing behavior.

## When to use

- After implementing a feature and the code works but feels heavy
- When a function or module is difficult to read or reason about
- When logic is duplicated across nearby files
- When naming, structure, or flow makes maintenance harder

## Scope

**YES - Refactor helper tasks:**
- Extract duplicate logic into small helpers
- Reduce nested conditionals and branching complexity
- Remove dead paths, redundant checks, or needless wrappers
- Improve naming where it increases clarity
- Break oversized functions into smaller units when behavior stays the same
- Tighten control flow so the main path is easier to read

**NO - Delegate to other skills:**
- Root-cause analysis for a failing bug -> `20-code_debug`
- New functionality -> `20-feature-implement`
- Broad architecture redesign -> `40-architecture-guard`
- Technical bug audit -> `40-audit-code`

## Workflow

1. **Read for intent**
   - Understand what the code is doing today.
   - Identify the smallest safe refactor that creates clarity.

2. **Find high-value cleanup**
   - Duplication
   - Deep nesting
   - Overly broad functions
   - Temporary or placeholder logic that became permanent
   - Names that hide intent

3. **Refactor carefully**
   - Keep interfaces stable unless the user asked otherwise.
   - Prefer several small edits over one large rewrite.

4. **Verify behavior**
   - Run targeted tests if available.
   - If no tests exist, explain the highest-risk area left behind.

## Optional Focuses

If the user provides one of these focuses, bias the refactor accordingly:

- `focus: dedupe` -> prioritize extracting repeated logic
- `focus: readability` -> prioritize naming and control flow clarity
- `focus: function-size` -> split large functions into smaller units
- `focus: cleanup` -> remove dead branches, redundant guards, and unused helpers
- `focus: testability` -> separate pure logic from I/O or side effects

## Objective Criteria (Yes/No)

- [ ] Preserved existing behavior
- [ ] Did not add new product behavior or rules
- [ ] Reduced complexity in at least one clear way
- [ ] Kept changes local and reviewable
- [ ] Verified with tests or explained remaining risk

## Expected Input

- File(s), function(s), or diff to simplify
- Project conventions or constraints, if any
- Optional focus such as `dedupe`, `readability`, or `testability`

## Expected Output

```text
REFACTOR REPORT

Target:
- What was simplified

Changes:
- The main simplifications applied

Behavior Safety:
- Why behavior should remain unchanged

Verification:
- Tests run or remaining risk
```

## Notes

- This skill replaces the vague "simplify anything" behavior with a practical refactor-helper workflow.
- Prefer deleting complexity over adding abstractions.
- If a cleanup uncovers a real bug, hand it to `20-code_debug` or `40-audit-code` depending on the situation.
