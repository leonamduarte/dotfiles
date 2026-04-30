---
name: ralph-create-json
description: Converte PRDs para o formato prd.json (ralph-tui).
---

# Ralph TUI - Create JSON Tasks

Converts PRDs to prd.json format for ralph-tui autonomous execution.

> **Note:** This skill is bundled with ralph-tui's JSON tracker plugin. Future tracker plugins (Linear, GitHub Issues, etc.) will bundle their own task creation skills.

> **⚠️ CRITICAL:** The output MUST be a FLAT JSON object with "name" and "userStories" at the ROOT level. DO NOT wrap content in a "prd" object or use "tasks" array. See "Schema Anti-Patterns" section below.


## Step 1: Extract Quality Gates

Look for the "Quality Gates" section in the PRD:

```markdown
## Quality Gates

These commands must pass for every user story:
- `pnpm typecheck` - Type checking
- `pnpm lint` - Linting

For UI stories, also include:
- Verify in browser using dev-browser skill
```

Extract:
- **Universal gates:** Commands that apply to ALL stories (e.g., `pnpm typecheck`)
- **UI gates:** Commands that apply only to UI stories (e.g., browser verification)

**If no Quality Gates section exists:** Ask the user what commands should pass, or use a sensible default like `npm run typecheck`.


## CRITICAL: Schema Anti-Patterns (DO NOT USE)

The following patterns are INVALID and will cause validation errors:

### ❌ WRONG: Wrapper object

```json
{
  "prd": {
    "name": "...",
    "userStories": [...]
  }
}
```

This wraps everything in a "prd" object. **DO NOT DO THIS.** The "name" and "userStories" fields must be at the ROOT level.

### ❌ WRONG: Using "tasks" instead of "userStories"

```json
{
  "name": "...",
  "tasks": [...]
}
```

The array is called **"userStories"**, not "tasks".

### ❌ WRONG: Complex nested structures

```json
{
  "metadata": {...},
  "overview": {...},
  "migration_strategy": {
    "phases": [...]
  }
}
```

Even if the PRD describes phases/milestones/sprints, you MUST flatten these into a single "userStories" array.

### ❌ WRONG: Using "status" instead of "passes"

```json
{
  "userStories": [{
    "id": "US-001",
    "status": "open"  // WRONG!
  }]
}
```

Use `"passes": false` for incomplete stories, `"passes": true` for completed.

### ✅ CORRECT: Flat structure at root

```json
{
  "name": "Android Kotlin Migration",
  "branchName": "ralph/kotlin-migration",
  "userStories": [
    {"id": "US-001", "title": "Create Scraper interface", "passes": false, "dependsOn": []},
    {"id": "US-002", "title": "Implement WeebCentralScraper", "passes": false, "dependsOn": ["US-001"]}
  ]
}
```


## Dependencies with `dependsOn`

Use the `dependsOn` array to specify which stories must complete first:

```json
{
  "id": "US-002",
  "title": "Create API endpoints",
  "dependsOn": ["US-001"],  // Won't be selected until US-001 passes
  ...
}
```

Ralph-tui will:
- Show US-002 as "blocked" until US-001 completes
- Never select US-002 for execution while US-001 is open
- Include "Prerequisites: US-001" in the prompt when working on US-002

**Correct dependency order:**
1. Schema/database changes (no dependencies)
2. Backend logic (depends on schema)
3. UI components (depends on backend)
4. Integration/polish (depends on UI)


## Conversion Rules

1. **Extract Quality Gates** from PRD first
2. **Each user story → one JSON entry**
3. **IDs**: Sequential (US-001, US-002, etc.)
4. **Priority**: Based on dependency order (1 = highest)
5. **dependsOn**: Array of story IDs this story requires
6. **All stories**: `passes: false` and empty `notes`
7. **branchName**: Derive from feature name, kebab-case, prefixed with `ralph/`
8. **Acceptance criteria**: Story criteria + quality gates appended
9. **UI stories**: Also append UI-specific gates (browser verification)


## Example

**Input PRD:**
```markdown
# PRD: Task Priority System

Add priority levels to tasks.

## Quality Gates

These commands must pass for every user story:
- `pnpm typecheck` - Type checking
- `pnpm lint` - Linting

For UI stories, also include:
- Verify in browser using dev-browser skill

## User Stories

### US-001: Add priority field to database
**Description:** As a developer, I need to store task priority.

**Acceptance Criteria:**
- [ ] Add priority column: 1-4 (default 2)
- [ ] Migration runs successfully

### US-002: Display priority badge on task cards
**Description:** As a user, I want to see task priority at a glance.

**Acceptance Criteria:**
- [ ] Badge shows P1/P2/P3/P4 with colors
- [ ] Badge visible without hovering

### US-003: Add priority filter dropdown
**Description:** As a user, I want to filter tasks by priority.

**Acceptance Criteria:**
- [ ] Filter dropdown: All, P1, P2, P3, P4
- [ ] Filter persists in URL
```

**Output prd.json:**
```json
{
  "name": "Task Priority System",
  "branchName": "ralph/task-priority",
  "description": "Add priority levels to tasks",
  "userStories": [
    {
      "id": "US-001",
      "title": "Add priority field to database",
      "description": "As a developer, I need to store task priority.",
      "acceptanceCriteria": [
        "Add priority column: 1-4 (default 2)",
        "Migration runs successfully",
        "pnpm typecheck passes",
        "pnpm lint passes"
      ],
      "priority": 1,
      "passes": false,
      "notes": "",
      "dependsOn": []
    },
    {
      "id": "US-002",
      "title": "Display priority badge on task cards",
      "description": "As a user, I want to see task priority at a glance.",
      "acceptanceCriteria": [
        "Badge shows P1/P2/P3/P4 with colors",
        "Badge visible without hovering",
        "pnpm typecheck passes",
        "pnpm lint passes",
        "Verify in browser using dev-browser skill"
      ],
      "priority": 2,
      "passes": false,
      "notes": "",
      "dependsOn": ["US-001"]
    },
    {
      "id": "US-003",
      "title": "Add priority filter dropdown",
      "description": "As a user, I want to filter tasks by priority.",
      "acceptanceCriteria": [
        "Filter dropdown: All, P1, P2, P3, P4",
        "Filter persists in URL",
        "pnpm typecheck passes",
        "pnpm lint passes",
        "Verify in browser using dev-browser skill"
      ],
      "priority": 3,
      "passes": false,
      "notes": "",
      "dependsOn": ["US-002"]
    }
  ]
}
```


## Checklist Before Saving

- [ ] Extracted Quality Gates from PRD (or asked user if missing)
- [ ] Each story completable in one iteration
- [ ] Stories ordered by dependency (schema → backend → UI)
- [ ] `dependsOn` correctly set for each story
- [ ] Quality gates appended to every story's acceptance criteria
- [ ] UI stories have browser verification (if specified in Quality Gates)
- [ ] Acceptance criteria are verifiable (not vague)
- [ ] No circular dependencies
