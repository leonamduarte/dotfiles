---
name: 10-repo_analysis
description: Mapeia repositorio e gera documentacao
compatibility: opencode
when_to_use: When starting work on a repository, need analysis.md, or need an implementation plan
allowed-tools: ["Read", "Glob", "Grep", "Write"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Analyze repository structure and generate documentation:
- **Mode scan**: `analysis.md` with hotspots, risks, invariants
- **Mode plan**: Implementation plan with files, modules, changes

## When to use

- Starting work on unknown repository
- When `analysis.md` is missing or outdated
- Before planning a feature (need context)
- When technical plan needs implementation

## Scope

**YES - Analysis & Documentation:**
- Scan repository structure
- Identify hotspots and risks
- Generate `analysis.md`
- Create implementation plans

**NO - Delegate to other skills:**
- Implement code -> `20-feature-implement`
- Detailed architecture validation → `40-architecture-guard`
- Code review → `40-audit-code` or `40-qa-review`

## Modes

### Mode: scan (default)
Generates `analysis.md` with:
- Overview
- Structure
- Hotspots (minimum 3 or "No relevant hotspots")
- Risks
- Invariants (minimum 2 or "Invariants not defined")
- Recommended Next Steps

### Mode: plan
Generates implementation plan with:
1. Files to modify
2. New modules or functions
3. Required changes
4. Potential risks

## Rules

- Read existing context files first (project.md, current-state.md, blueprints.md, architecture-decisions.md)
- Generate requested output format
- Never modify source code files
- Only write to documentation files (`analysis.md`) when scan output is requested

## Objective Criteria (Yes/No)

### For scan mode:
- [ ] Read existing context files
- [ ] analysis.md has: Overview, Structure, Hotspots, Risks, Invariants, Next Steps
- [ ] Lists at least 3 hotspots or explicitly states "No relevant hotspots"
- [ ] Lists at least 2 invariants or explicitly states "Invariants not defined"

### For plan mode:
- [ ] Read relevant context files
- [ ] Plan contains: Files, Modules, Changes, Risks
- [ ] Clear implementation points identified

## Expected Input

- Repository path
- Mode: scan | plan
- Business/product context (if available)
- Existing governance documents (if any)

## Expected Output

**Mode scan**: `analysis.md` created/updated

**Mode plan**: Structured plan:
```
PLAN
1. Files to modify
2. New modules or functions
3. Required changes
4. Potential risks
END PLAN
```

## Examples

**Scan mode:**
```
skill: repo_analysis
mode: scan
target: ./my-project
Output: analysis.md with hotspots and risks
```

**Plan mode:**
```
skill: repo_analysis
mode: plan
task: "Add payment processing"
Output: Implementation plan with files and changes
```

## Notes

- Use `scan` when starting on new repository
- Use `plan` when you have a technical spec to implement
- Analysis is structural, not code-level (use 40-audit-code for that)
