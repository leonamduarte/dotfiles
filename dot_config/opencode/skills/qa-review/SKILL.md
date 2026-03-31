---
name: qa-review
description: Quality review for merge - tests, process, and overall readiness
compatibility: opencode
when_to_use: Before merging code to ensure it meets quality standards for tests and process
allowed-tools: []
model: inherit
user-invocable: true
context: inline
---

## Goal

Ensure code is ready to merge by reviewing test coverage, code quality standards, documentation, and merge readiness. Focus on PROCESS and READINESS, not technical bug detection.

## When to use

- Before merging pull requests or code changes
- When preparing code for release
- When reviewing auto-generated code for production readiness
- After bug fixes for final validation before merge
- When assessing if feature is "done" (Definition of Done)

## Scope (What THIS skill does)

**YES - Quality & Process:**
- Test coverage and quality (unit tests, integration tests, edge case coverage)
- Code quality standards (naming, function size, separation of concerns)
- Documentation completeness (README, API docs, inline comments)
- Error handling quality (proper propagation, clear messages)
- Performance considerations (obvious bottlenecks, N+1 patterns)
- Logging and observability
- Merge readiness assessment (approval recommendation)

**NO - Delegate to other skills:**
- Technical bugs and security issues → `audit-code`
- Deep architecture violations → `architecture-guard`
- Code refactoring/simplification → `code-simplifier`
- Complex bug diagnosis → `code_debug`

## Rules

- Focus on READINESS to merge, not just correctness
- Check "Definition of Done" items
- Never modify files - only review and report
- Give clear merge recommendation (Approved / Approved with conditions / Not ready)

## Optional Focuses

If the user adds one of these focuses, bias the review accordingly:

- `focus: tests` -> spend extra effort on missing scenarios, brittle tests, and verification gaps
- `focus: merge-readiness` -> prioritize release blockers, rollout confidence, and unresolved follow-ups
- `focus: docs` -> prioritize README, public API docs, examples, and operator guidance
- `focus: observability` -> prioritize logging, metrics, debugging signals, and actionable failures
- `focus: generate-tests` -> in addition to the review, propose concrete test cases or skeletons for the biggest gaps

## Objective Criteria (Yes/No)

- [ ] Reviewed test coverage (critical logic, edge cases, error paths)
- [ ] Reviewed code quality (naming, function size, separation of concerns)
- [ ] Reviewed documentation (README, API docs, inline where needed)
- [ ] Reviewed error handling (proper propagation, clear messages)
- [ ] Reviewed performance (obvious issues, N+1 patterns)
- [ ] Reviewed logging/observability (debuggability)
- [ ] Assessed merge readiness
- [ ] Did NOT check: technical bugs, security issues (delegated to audit-code)
- [ ] Did NOT modify any files
- [ ] Delivered clear merge recommendation

## Expected Input

- Diff, branch, or list of files to review
- Context of the change (feature/bug/refactor)
- Specific quality requirements (if any)
- Definition of Done checklist (if available)

## Expected Output

**Quality Assessment by Category:**

### Tests
- Coverage status for critical paths
- Missing test scenarios identified
- Test quality observations

### Code Quality
- Naming and clarity issues
- Function/module size concerns
- Separation of concerns

### Documentation
- README/API docs completeness
- Missing inline documentation
- Clarity of public interfaces

### Error Handling & Observability
- Error propagation quality
- Logging adequacy
- Debuggability

### Performance
- Obvious bottlenecks
- Redundant operations
- Resource usage concerns

### Merge Recommendation
- **Approved**: Ready to merge
- **Approved with conditions**: Minor issues, address before merge
- **Not ready**: Significant issues must be resolved

## Examples

**Input:** "Review feature for merge readiness"

**Output:**

**Tests**: ✅ Well covered (unit + integration)
**Code Quality**: ⚠️ Some functions too long (suggested refactoring)
**Documentation**: ❌ API docs missing
**Error Handling**: ✅ Proper error propagation
**Performance**: ✅ No obvious issues
**Merge Recommendation**: Approved with conditions - add API docs before merge

## Notes

- This is a QUALITY ASSURANCE skill - focus on process and readiness
- For technical bugs and security, use `audit-code`
- For code simplification, use `code-simplifier`
- For architecture validation, use `architecture-guard`
- Use both `audit-code` AND `qa-review` before merging important changes
- If you need help filling test gaps, pass `focus: generate-tests` so the review includes concrete test suggestions
