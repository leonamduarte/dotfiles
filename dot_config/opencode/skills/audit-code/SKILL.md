---
name: audit-code
description: Audit code for bugs, security vulnerabilities, and edge cases
compatibility: opencode
when_to_use: When you need to find technical bugs, security issues, and edge cases in code
allowed-tools: []
model: inherit
user-invocable: true
context: inline
---

## Goal

Find technical bugs, security vulnerabilities, and edge case issues in code changes. Focus ONLY on correctness and safety issues.

## When to use

- After implementing a feature to catch bugs early
- After fixing a bug to verify the fix is complete
- Before applying fixes from audit findings
- When security review is needed
- For targeted technical bug hunting (NOT general quality review)

## Scope (What THIS skill does)

**YES - Technical Issues:**
- Bugs and logic errors
- Security vulnerabilities (injections, unsafe eval, unvalidated input, secrets exposure)
- Edge cases and boundary conditions
- Race conditions and concurrency issues
- Null/undefined handling problems
- Type safety issues
- Resource leaks

**NO - Delegate to other skills:**
- Code style or naming issues → `code-simplifier`
- Architecture violations → `architecture-guard`
- Test coverage gaps → `qa-review`
- General quality assessment → `qa-review`
- Performance optimization → `qa-review`
- Refactoring suggestions → `code-simplifier`
- Documentation review → `qa-review`

## Rules

- Focus ONLY on bugs, security, and edge cases
- Never modify files - only report findings
- Be specific: file:line or exact symbol reference
- Categorize severity clearly
- If no issues found, explicitly state "No issues found"

## Objective Criteria (Yes/No)

- [ ] Checked for logic bugs and errors
- [ ] Checked for security vulnerabilities (injections, eval, input validation, secrets)
- [ ] Checked for edge cases and boundary conditions
- [ ] Checked for race conditions and concurrency issues
- [ ] Checked for null/undefined handling
- [ ] All findings specify exact location (file:line)
- [ ] All findings have severity: Critical, High, Medium, or Low
- [ ] Did NOT check: code style, naming, test coverage, architecture (delegated)
- [ ] Did NOT modify any files
- [ ] Explicitly stated if no issues found

## Expected Input

- Diff, branch, or list of changed files
- Brief context of the change (feature/bug/refactor)
- Any relevant invariants or constraints

## Expected Output

**Table format:**
| File | Severity | Issue Type | Description | Location |
|------|----------|------------|-------------|----------|

**Summary:**
- Total issues by severity
- Explicit "No issues found" if applicable

## Examples

**Input:** "Review auth module changes"

**Output:**
| File | Severity | Issue Type | Description | Location |
|------|----------|------------|-------------|----------|
| auth.ts | Critical | Security | SQL injection possible | Line 45 |
| login.ts | High | Bug | Null pointer on edge case | Line 120 |
| session.ts | Medium | Edge Case | Token expiration not handled | Line 88 |

Total: 1 Critical, 1 High, 1 Medium

**OR**

No issues found.

## Notes

- This is a TECHNICAL audit skill - focus on correctness and security only
- For comprehensive quality review including tests and process, use `qa-review`
- For code simplification and refactoring, use `code-simplifier`
- For architecture validation, use `architecture-guard`
