---
name: parallel
description: Executa multiplas skills em paralelo
compatibility: opencode
when_to_use: When you need multiple perspectives on code changes or complex tasks
allowed-tools: ["Read", "Glob", "Grep", "Bash", "skill", "Agent"]
model: inherit
user-invocable: true
context: fork
agent: worker
effort: 3
---

## Goal

Launch multiple skills/agents in parallel to analyze, review, or process tasks from different angles simultaneously.

## When to use

- After implementing a feature - run audit + qa-review + architecture-guard in parallel
- Before committing changes - parallel verification
- When reviewing code - multiple review perspectives
- For complex refactors - analysis from different angles

## Rules

- Define clear, non-overlapping scopes for each parallel agent
- Agents run independently and concurrently
- Aggregate results after all agents complete
- Preserve full context when spawning agents
- Use skill: for simple delegation, Agent tool for complex work

### Parallel Agent Types

**Review Agents (3-way review pattern):**

1. **audit-code agent** - Security and bug detection
   - Scope: Find bugs, edge cases, security risks
   - Output: Table of findings (file | severity | issue | suggestion)

2. **code-simplifier agent** - Code quality and simplicity
   - Scope: Redundancy, complexity, unnecessary code
   - Output: Simplification suggestions

3. **architecture-guard agent** - Architecture compliance
   - Scope: Pattern violations, structural issues
   - Output: Architecture concerns

**Implementation Agents:**

4. **feature-implement agent** - Feature development
   - Scope: Write/edit code based on requirements
   - Output: Implemented changes

5. **qa-review agent** - Quality assurance
   - Scope: Test coverage, edge cases, validation
   - Output: QA report

### Objective Criteria (Yes/No)

- [ ] Defined clear scopes for each parallel agent (no overlap)
- [ ] Launched all agents in a single operation (parallel)
- [ ] Provided full context to each agent
- [ ] Waited for all agents to complete
- [ ] Aggregated findings into coherent summary
- [ ] Presented results in structured format

## Expected Input

- Task description to be analyzed
- List of skills/agents to run in parallel
- Context about what to analyze (files, diff, etc.)
- Optional: specific focus areas for each agent

## Expected Output

- Aggregated results from all parallel agents
- Structured comparison of findings
- Clear action items prioritized by severity
- Summary of recommendations

## Execution Flow

1. **Identify Target**: Determine what needs analysis (files, diff, feature)

2. **Define Agents**: Choose which skills/agents to run in parallel
   - Use existing skills for standard work
   - Use Agent tool for custom analysis

3. **Launch Parallel**: Spawn all agents simultaneously with:
   - Clear individual scopes
   - Full shared context
   - Same target files/diff

4. **Collect Results**: Wait for all agents to complete

5. **Aggregate & Report**:
   - Merge findings into single coherent view
   - Resolve conflicts if agents disagree
   - Prioritize by severity/importance
   - Present structured report

## Usage Patterns

### Post-Implementation Review
```
Run parallel:
1. skill: audit-code (find bugs)
2. skill: code-simplifier (simplify code)
3. skill: architecture-guard (check patterns)
Target: Recent changes or specific files
```

### Pre-Commit Verification
```
Run parallel:
1. skill: qa-review (tests & coverage)
2. skill: audit-code (bugs & risks)
3. Check for lint/type errors
Target: Staged changes or PR diff
```

### Complex Refactor Analysis
```
Run parallel:
1. skill: repo_analysis (understand structure)
2. Agent: Analyze dependencies
3. Agent: Identify breaking changes
Target: Refactor scope
```

## Notes

- Each agent should have distinct scope to avoid duplicate work
- Use `context: fork` to run in isolated sub-agent
- `effort: 3` provides adequate token budget for parallel work
- Aggregate results rather than presenting raw agent outputs
- Consider agent completion time when choosing parallelism level

## Example Invocation

**Input**: "Review my recent changes to the auth system"

**Parallel Execution**:
1. `skill: audit-code` - Find security issues
2. `skill: code-simplifier` - Simplify auth logic
3. `skill: architecture-guard` - Check architecture compliance

**Output**: Aggregated report with:
- Security findings (from audit-code)
- Simplification suggestions (from code-simplifier)
- Architecture concerns (from architecture-guard)
- Prioritized action items
