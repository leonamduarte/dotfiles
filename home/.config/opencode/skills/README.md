This directory is a generated compatibility mirror of the canonical skills
repository located at "home/.agents/skills".

Do not edit files here directly. Make changes in:

  home/.agents/skills/

and then run the synchronization script at:

  scripts/sync-opencode-skills.ps1

Workflow
- Edit or add skills under home/.agents/skills
- Run `scripts/sync-opencode-skills.ps1 -DryRun` and review the output
- Run `scripts/sync-opencode-skills.ps1` to apply the mirror to this directory

The mirror removes legacy entries (for example `90-mcp-bootstrap`) and
keeps this tree aligned with the canonical source. This file exists to
document that the contents are generated and must not be edited in-place.
