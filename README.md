# dotfiles — Agent Configuration

## Agent files

Versioned agent configuration lives under `home/.agents/`:

| Tool   | Config path                              |
|--------|------------------------------------------|
| Gemini | `home/.agents/gemini/agents/*.md`        |
| Gemini | `home/.agents/gemini/policy.toml`        |
| Codex  | `home/.agents/codex/agents/*.toml`       |
| Codex  | `home/.agents/codex/config.toml`         |
| Skills | `home/.agents/skills/*/SKILL.md`         |

## Windows symlink for Gemini CLI

Gemini CLI expects its config at `%USERPROFILE%\.gemini`.
On Windows, create a junction so the CLI reads the versioned files:

```powershell
New-Item -ItemType Junction -Path "$env:USERPROFILE\.gemini" -Target "<repo>\home\.agents\gemini"
```

After this, `gemini` reads agents from the repo-managed directory.

## Runtime state

`home/.codex/` contains Codex runtime state (cache, logs, sessions, auth).
It is **not** versioned. Only `home/.agents/codex/` (config) is tracked.

## Validation

```powershell
.\scripts\validate-gemini-agents.ps1
```

Checks that every agent `.md` has valid frontmatter with `name`, `description`, `model`, and `tools`, and that the model is one of the approved values.

## Daily npm tool update

Use `scripts/update-npm-tools.ps1` to refresh the main global CLIs (`opencode-ai`, `@openai/codex`, `@google/gemini-cli`) and the rest of your global npm packages.

Recommended scheduled task:

```powershell
.\scripts\npm-update-logon.ps1
```

Run PowerShell **as Administrator** before creating the task, otherwise Windows will refuse `-RunLevel Highest`.
