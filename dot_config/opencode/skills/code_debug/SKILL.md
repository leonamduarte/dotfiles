---
name: code_debug
description: Smart debugging for failing code, tests, and multi-file bugs
compatibility: opencode
when_to_use: When there is a concrete failure to reproduce, explain, isolate, and fix
allowed-tools: ["Read", "Glob", "Grep", "Bash", "Edit", "Write"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Debug failing code with a practical workflow: reproduce, isolate, identify root cause, propose the smallest safe fix, and verify the result.

## When to use

- Failing tests or commands
- Runtime errors and stack traces
- Regressions after recent changes
- Multi-file bugs where the cause is unclear
- Flaky behavior that needs structured investigation

## Scope

**YES - Smart debug workflow:**
- Reproduce the failure first
- Read stack traces, logs, and failing output closely
- Trace the execution path across related files
- Form a root-cause hypothesis before editing
- Apply the smallest fix that addresses the real cause
- Re-run the relevant verification after the fix

**NO - Delegate to other skills:**
- Broad architecture review -> `architecture-guard`
- General code cleanup without a concrete failure -> `code-simplifier`
- New feature work -> `feature-implement`
- Broad bug/security sweep without a specific failure -> `audit-code`

## Workflow

1. **Reproduce**
   - Run the failing command, test, or scenario.
   - Capture the exact error, stack trace, and inputs.

2. **Isolate**
   - Identify the narrowest failing unit: function, module, code path, or integration boundary.
   - Read only the most relevant files first.

3. **Hypothesize**
   - State the likely root cause in one or two sentences.
   - Prefer evidence over guesses.

4. **Fix**
   - Make the smallest change that resolves the root cause.
   - Avoid opportunistic refactors unless they are required for the fix.

5. **Verify**
   - Re-run the failing test/command.
   - If possible, verify the adjacent edge case that likely caused the bug.

## Optional Focuses

If the user provides one of these focuses, bias the investigation accordingly:

- `focus: stack-trace` -> start from the deepest relevant frame and walk outward
- `focus: flaky-test` -> look for timing, shared state, randomness, or cleanup issues
- `focus: regression` -> compare recent changes and identify what changed behavior
- `focus: data-flow` -> trace values across modules and validation boundaries
- `focus: async` -> prioritize ordering, race conditions, retries, and awaited work

## Objective Criteria (Yes/No)

- [ ] Reproduced the failure or explained clearly why reproduction was not possible
- [ ] Captured the concrete failing symptom
- [ ] Identified the probable root cause
- [ ] Changed only the code necessary for the fix
- [ ] Re-ran a relevant verification step after the change
- [ ] Reported remaining uncertainty, if any

## Expected Input

- Error message, stack trace, failing command, or failing test name
- Relevant files or feature area, if known
- Recent context about when the failure started

## Expected Output

```text
DEBUG REPORT

Symptom:
- What failed and where

Root Cause:
- The most likely underlying cause

Fix:
- The minimal change made or proposed

Verification:
- What was re-run and what happened

Follow-up:
- Remaining risk or next check, if any
```

## Notes

- Start with evidence, not assumptions.
- Prefer a minimal targeted fix over a broad rewrite.
- If the bug disappears but the cause is still uncertain, say so explicitly.
