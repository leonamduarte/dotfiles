---
name: 10-repo_analysis
description: Mapeia repositorio e gera documentacao
compatibility: opencode
when_to_use: When starting work on a repository, need analysis.md, or missing memory files
allowed-tools: ["Read", "Glob", "Grep", "Write"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Analyze repository structure and generate documentation:
- **Mode scan**: `analysis.md` with hotspots, risks, invariants
- **Mode plan**: Implementation plan with files, modules, changes
- **Mode memory**: `memory/*.md` files (repo_summary, architecture, recent_changes)

## When to use

- Starting work on unknown repository
- When `analysis.md` is missing or outdated
- When memory files are missing or outdated
- Before planning a feature (need context)
- When technical plan needs implementation

## Scope

**YES - Analysis & Documentation:**
- Scan repository structure
- Identify hotspots and risks
- Generate `analysis.md`
- Generate/update `memory/*.md` files
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

### Mode: memory
Generates/updates memory files:
- `memory/repo_summary.md` - Repository overview
- `memory/architecture.md` - Architecture description
- `memory/recent_changes.md` - Recent modifications

## Rules

- Read existing context files first (project.md, current-state.md, blueprints.md, architecture-decisions.md)
- Generate requested output format
- Never modify source code files
- Only write to documentation files (analysis.md, memory/*.md)

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

### For memory mode:
- [ ] Generated repo_summary.md with repository overview
- [ ] Generated architecture.md with structure description
- [ ] Generated recent_changes.md with modifications
- [ ] All files in `memory/` directory

## Expected Input

- Repository path
- Mode: scan | plan | memory
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

**Mode memory**: Updated `memory/` directory with:
- `repo_summary.md`
- `architecture.md`
- `recent_changes.md`

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

**Memory mode:**
```
skill: repo_analysis
mode: memory
target: ./my-project
Output: memory/repo_summary.md, memory/architecture.md, memory/recent_changes.md
```

## Notes

- Mode `memory` is the built-in path for generating or refreshing memory files
- Use `scan` when starting on new repository
- Use `plan` when you have a technical spec to implement
- Use `memory` when memory files are missing/outdated
- Analysis is structural, not code-level (use 40-audit-code for that)
