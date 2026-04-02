---
name: 20-feature-implement
description: Implementa features novas
compatibility: opencode
when_to_use: When a feature or small functional improvement is defined well enough to build safely
allowed-tools: ["Read", "Glob", "Grep", "Edit", "Write", "Bash"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Implement the smallest useful version of the requested feature without breaking project invariants.

## When to use

- New feature with defined scope
- Low-to-medium impact functional improvement
- Targeted behavior correction when there is no formal audit report

## Rules

- Scope: implement only what was requested in the ticket or prompt
- Not in scope: full audit backlog cleanup -> delegate to `50-apply-audit-fixes`
- Not in scope: deep diagnosis of intermittent bugs -> delegate to `20-code_debug`
- Not in scope: structural repository documentation -> delegate to `10-repo_analysis`
- Protected files: `AGENTS.md`, `project.md`, `blueprints.md`, `architecture-decisions.md`, `current-state.md`

## Workflow

1. Read the relevant context and nearby code first
2. Implement the smallest complete slice that satisfies the request
3. Keep changes local and avoid unrelated rewrites
4. Add or update validation where it gives confidence
5. Explain what changed, why, and how to verify it

## Optional Focuses

If the user adds one of these focuses, bias the implementation accordingly:

- `focus: minimal` -> do the narrowest possible implementation with minimal surface area
- `focus: tests` -> prioritize adding or updating targeted tests along with the feature
- `focus: generate-tests` -> if the implementation is straightforward, also create test cases or test skeletons for the new behavior
- `focus: safety` -> prioritize validation, error handling, and backward-compatible changes
- `focus: integration` -> prioritize wiring between existing modules instead of introducing new abstractions

## Objective Criteria (Yes/No)

- [ ] Read the existing context files among `project.md`, `current-state.md`, `blueprints.md`, and `architecture-decisions.md` when they exist
- [ ] Did not change governance files
- [ ] If there is architectural impact, stated it explicitly before applying broad changes
- [ ] Included a test for new behavior or a fixed bug when a test suite exists
- [ ] Responded with: `What changed`, `Why`, `How to test`, `Limitations and next steps`

## Expected Input

- Clear functional requirement (ticket, prompt, or story)
- Context about the current state of the affected module
- Relevant technical constraints (performance, security, compatibility)

## Expected Output

- Implemented code with the smallest useful scope
- Tests and objective validation steps

## Execute Mode

When a detailed technical plan already exists (from `10-repo_analysis` or equivalent):
- Follow the plan closely
- Modify only the necessary files
- Produce minimal patches
- Avoid rewriting large sections
- Include a test when a test suite exists

## Notes

- This skill stays implementation-focused; it does not become a dedicated test generator.
- Use `focus: tests` or `focus: generate-tests` when you want lightweight test help without introducing a separate skill.
