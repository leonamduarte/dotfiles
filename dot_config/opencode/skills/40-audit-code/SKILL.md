---
name: 40-audit-code
description: Audita bugs, seguranca e edge cases
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
- Code style or naming issues → `20-code-simplifier`
- Architecture violations → `40-architecture-guard`
- Test coverage gaps → `40-qa-review`
- General quality assessment → `40-qa-review`
- Performance optimization → `40-qa-review`
- Refactoring suggestions → `20-code-simplifier`
- Documentation review → `40-qa-review`

## Rules

- Focus ONLY on bugs, security, and edge cases
- Never modify files - only report findings
- Be specific: file:line or exact symbol reference
- Categorize severity clearly
- If no issues found, explicitly state "No issues found"

## Optional Focuses

If the user adds one of these focuses, narrow the audit accordingly:

- `focus: security` -> prioritize injection risks, auth/authz gaps, secrets exposure, unsafe execution
- `focus: edge-cases` -> prioritize null handling, empty inputs, boundary values, retries, and fallback paths
- `focus: concurrency` -> prioritize races, ordering issues, shared mutable state, and missing awaits
- `focus: data-validation` -> prioritize schema gaps, unchecked inputs, coercion mistakes, and trust boundaries
- `focus: performance` -> allow a narrow technical performance pass for obvious hot-path correctness risks only; broader optimization still belongs to `40-qa-review`

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
- Optional `focus: ...` hint when a risk area is already known

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
| auth.ts | Critical | Security | SQL injection possible | auth.ts:45 |
| login.ts | High | Bug | Null pointer on edge case | login.ts:120 |
| session.ts | Medium | Edge Case | Token expiration not handled | session.ts:88 |

Total: 1 Critical, 1 High, 1 Medium

**OR**

No issues found.

## Notes

- This is a TECHNICAL audit skill - focus on correctness and security only
- For comprehensive quality review including tests and process, use `40-qa-review`
- For code simplification and refactoring, use `20-code-simplifier`
- For architecture validation, use `40-architecture-guard`
- If you already know the area of risk, pass a `focus:` hint to make the audit faster and sharper
