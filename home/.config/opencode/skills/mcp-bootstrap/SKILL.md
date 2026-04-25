---
name: mcp-bootstrap
description: Bootstraps Codex MCP configuration for a repository or user profile
---

## Objective

Set up MCP configuration for the shared `.agents` source of truth and the
runtime links consumed by Codex and Gemini CLI:

- repo-local `.agents/<tool>/` for project-specific config
- user-wide `~/.agents/<tool>/` for defaults shared across repositories
- `~/.codex/` and `~/.gemini/` as compatibility/runtime links
- `~/.agents/skills` for the reusable skill itself

## When to use

- A new repository needs MCP servers for Codex
- An existing Codex setup needs extra MCP servers
- A user wants shared defaults that apply across repositories

## Rules

- Never use absolute paths inside repo-local config
- Use `.` as the project root when a local MCP server needs a root path
- Preserve existing Codex config and append minimally
- Do not overwrite existing runtime config unless necessary
- Do not modify application code
- Prefer repo-local `.agents/<tool>/...` for project-specific servers and
  `~/.agents/<tool>/...` only for user-wide defaults
- If a skill needs MCP dependencies, declare them in `agents/openai.yaml`
  rather than burying them in prose
- Add .agents to gitignore

## Workflow

1. Inspect the existing config in the repo and in `HOME`
2. Decide whether the change is repo-local or user-global
3. Add only the missing MCP server entries
4. Validate that Codex can see the servers and that nothing existing was clobbered

## Output

- Files changed
- Scope chosen
- Validation commands
- Remaining gaps

## Validation

- Confirm the relevant files exist in the expected Codex location
- Restart Codex if the skill does not appear after a change
- Verify the configured servers from the Codex UI or the available MCP listing command
