<#
  update-npm-tools.ps1

  Daily updater for global npm tools.

  Focuses on:
  - opencode-ai
  - @openai/codex
  - @google/gemini-cli
  - any other globally installed npm packages

  Usage:
    .\update-npm-tools.ps1
    .\update-npm-tools.ps1 -DryRun

  Notes:
  - Uses `npm install -g <pkg>@latest` for the chosen CLIs.
  - Uses `npm update -g` for the rest of the global npm packages.
  - Writes a log next to this script by default.
#>

param(
    [switch]$DryRun,
    [string]$Log = "$(Join-Path $PSScriptRoot 'update-npm-tools.log')"
)

$ErrorActionPreference = 'Stop'

function Write-Log {
    param([string]$Message)
    $line = "$(Get-Date -Format o) - $Message"
    $line | Tee-Object -FilePath $Log -Append
}

function Invoke-Step {
    param(
        [string]$Title,
        [scriptblock]$Action
    )

    Write-Host "`n[$Title]" -ForegroundColor Cyan
    Write-Log "Starting: $Title"

    if ($DryRun) {
        Write-Host "[DryRun] Skipped." -ForegroundColor Yellow
        Write-Log "[DryRun] Skipped: $Title"
        return
    }

    & $Action
    Write-Log "Finished: $Title"
}

$targets = @(
    'opencode-ai',
    '@openai/codex',
    '@google/gemini-cli'
)

Write-Log '=== npm tool update run ==='
Write-Host "Log: $Log"

foreach ($pkg in $targets) {
    Invoke-Step -Title "Install latest: $pkg" -Action {
        npm install -g "$pkg@latest" 2>&1 | Tee-Object -FilePath $Log -Append
        if ($LASTEXITCODE -ne 0) {
            throw "npm install failed for $pkg (exit code $LASTEXITCODE)"
        }
    }
}

Invoke-Step -Title 'Update all global npm packages' -Action {
    npm update -g 2>&1 | Tee-Object -FilePath $Log -Append
    if ($LASTEXITCODE -ne 0) {
        throw "npm update -g failed (exit code $LASTEXITCODE)"
    }
}

Write-Host "`nDone." -ForegroundColor Green
Write-Log 'Done.'
