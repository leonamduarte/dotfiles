---
name: fork
description: Execute skills in isolated fork contexts (sub-agents)
compatibility: opencode
when_to_use: When you need isolated execution, separate token budgets, or bubble-up permissions
allowed-tools: ["skill", "Agent", "Read", "Bash"]
model: inherit
user-invocable: true
context: fork
agent: worker
effort: 2
---

## Goal

Execute skills in isolated fork contexts with separate token budgets and permission bubbling. Creates clean execution environment that doesn't pollute parent conversation.

## When to use

- **Isolation needed**: Skill execution shouldn't affect parent context
- **Token budget**: Separate budget from main conversation
- **Permission bubbling**: Parent should review before changes are made
- **Clean slate**: Start fresh without previous conversation history
- **Parallel execution**: Run multiple independent tasks simultaneously
- **Cache optimization**: Preserve cache-identical prefixes for performance

## Rules

- Fork creates new isolated context with own token budget
- Parent context is preserved but not modified by fork
- Results bubble up to parent for review/approval
- Multiple forks can run in parallel
- Fork inherits parent's tool pool unless overridden

### Fork Execution Modes

**1. Simple Fork (skill delegation)**
```
fork → skill: audit-code
Result: Returns to parent when complete
Use for: Simple isolated tasks
```

**2. Agent Fork (sub-agent with custom system prompt)**
```
fork → Agent with subagent_type="worker"
Result: Streamed execution, parent can monitor
Use for: Complex multi-step work
```

**3. Permission Bubble Fork**
```
fork with permission_mode="bubble"
Result: All changes require parent approval
Use for: Destructive operations
```

### Objective Criteria (Yes/No)

- [ ] Determined if fork is necessary (isolation/budget/bubbling)
- [ ] Selected appropriate fork mode
- [ ] Configured token budget (effort level)
- [ ] Set up permission mode correctly
- [ ] Launched fork with full context
- [ ] Collected and presented results
- [ ] Cleaned up fork context if needed

## Expected Input

- Skill or agent to execute in fork
- Target files/context for the fork
- Token budget level (effort: 1-5)
- Permission mode (acceptEdits, bubble, plan)
- Optional: custom system prompt

## Expected Output

- Fork execution results
- Summary of work performed in isolated context
- Any artifacts produced (files, reports)
- Token usage summary (if available)

## Execution Flow

### Phase 1: Fork Configuration

1. **Determine Fork Type**:
   - Simple skill fork → direct delegation
   - Complex agent fork → use Agent tool
   - Permission bubble → set mode appropriately

2. **Configure Budget**:
   - effort: 1 (minimal) - Quick checks
   - effort: 2 (low) - Simple edits
   - effort: 3 (medium) - Standard work
   - effort: 4 (high) - Complex refactors
   - effort: 5 (maximum) - Deep analysis

3. **Set Context**:
   - Prepare all relevant files/context
   - Ensure fork has everything needed
   - Don't rely on parent conversation history

### Phase 2: Fork Execution

1. **Launch Fork**:
   ```
   context: fork
   agent: worker
   Launch skill/agent with isolated context
   ```

2. **Monitor (optional)**:
   - For long-running forks, stream progress
   - Parent can review intermediate results
   - Cancel if needed

### Phase 3: Result Collection

1. **Collect Output**:
   - Gather all results from fork
   - Extract relevant findings
   - Preserve formatting

2. **Present to Parent**:
   - Summarize fork execution
   - Show key findings/changes
   - Include token usage if available

## Usage Patterns

### Pattern 1: Isolated Code Review
```
Task: Review auth module changes
Fork: skill: audit-code
      target: auth/*
      effort: 2
      mode: bubble (parent reviews findings)
Result: Security audit report
```

### Pattern 2: Parallel Implementation
```
Task: Implement API endpoints
Fork 1: skill: feature-implement for users API
Fork 2: skill: feature-implement for orders API
Fork 3: skill: feature-implement for products API
Parallel execution, independent budgets
```

### Pattern 3: Deep Analysis
```
Task: Analyze codebase architecture
Fork: skill: repo_analysis
      scope: deep
      effort: 4
      isolation: remote (full separation)
Result: Comprehensive architecture report
```

### Pattern 4: Permission Bubble
```
Task: Refactor database schema
Fork: Agent with mode="bubble"
      All edits require parent approval
      Parent reviews each change before application
```

## Fork vs. Inline Comparison

| Aspect | Inline (context: inline) | Fork (context: fork) |
|--------|-------------------------|---------------------|
| **Context** | Shares parent conversation | Isolated, clean slate |
| **Token Budget** | Shared with parent | Separate (effort-based) |
| **History** | Full conversation history | Only provided context |
| **Permissions** | Inherited from parent | Configurable (bubble mode) |
| **Performance** | Faster (no setup) | Slower (fork overhead) |
| **Use for** | Quick tasks, conversation | Heavy work, isolation |

## Advanced Configuration

### Custom System Prompt
```yaml
---
name: custom-fork-task
description: Specialized fork with custom prompt
context: fork
agent: worker
effort: 3
system_prompt: |
  You are a specialized code reviewer focused on performance.
  Always check for: N+1 queries, memory leaks, hot paths.
---
```

### Isolation Levels

1. **Worktree** (isolation: worktree):
   - Separate git worktree
   - Can make commits independently
   - Clean rollback

2. **Remote** (isolation: remote):
   - Full remote execution
   - Complete separation
   - Used for dangerous operations

3. **Local** (default):
   - Same filesystem
   - Process-level isolation
   - Fastest option

### Token Budget Guidelines

```
effort: 1  → ~2K tokens   (Quick file read)
effort: 2  → ~5K tokens   (Simple edits)
effort: 3  → ~10K tokens  (Standard feature)
effort: 4  → ~25K tokens  (Complex refactor)
effort: 5  → ~50K tokens  (Deep analysis)
```

## Best Practices

1. **Use sparingly** - Forks have overhead, use inline for simple tasks
2. **Full context** - Always provide complete context, no conversation history
3. **Clear scope** - Define exactly what the fork should accomplish
4. **Budget appropriately** - Don't waste tokens on simple tasks
5. **Bubble for safety** - Use bubble mode for destructive operations
6. **Parallel wisely** - Only parallelize truly independent work
7. **Clean up** - Document any side effects

## Integration with Parallel Skill

The `fork` skill works great with `parallel`:

```
parallel {
  fork → skill: audit-code
  fork → skill: code-simplifier
  fork → skill: architecture-guard
}
All three run in isolated forks simultaneously
Results aggregated by parallel skill
```

## Error Handling

- Fork failures are reported to parent
- Parent can retry with different configuration
- Partial results are still collected
- Budget exceeded errors clearly reported

## Notes

- `context: fork` requires `agent: worker` specification
- Forks inherit parent's allowed-tools by default
- Use `isolation: remote` for maximum safety
- Token budgets are estimates, not strict limits
- Results may need formatting for parent context
