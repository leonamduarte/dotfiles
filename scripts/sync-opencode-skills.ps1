<#
  sync-opencode-skills.ps1

  Mirror the skills tree from home/.agents/skills -> config/.config/opencode/skills

  Usage:
    .\sync-opencode-skills.ps1 -DryRun   # show what would be done
    .\sync-opencode-skills.ps1          # perform mirror (default)

  Implementation notes:
  - Uses robocopy to perform an efficient mirror (/MIR). Robocopy exit codes <= 8 are treated as success.
  - Excludes common VCS/artifact directories and the legacy 90-mcp-bootstrap.
  - Writes a simple log to the scripts directory.
#>

param(
    [switch]$DryRun,
    [string]$Log = "$(Join-Path $PSScriptRoot 'sync-opencode-skills.log')"
)

function Write-Log {
    param($Message)
    $line = "$(Get-Date -Format o) - $Message"
    $line | Tee-Object -FilePath $Log -Append
}

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$SourceRoot = Join-Path $RepoRoot "home\.agents\skills"
$TargetRoot = Join-Path $RepoRoot "config\.config\opencode\skills"

if (-not (Test-Path $SourceRoot)) {
    throw "Source skill tree not found: $SourceRoot"
}

if (-not (Test-Path $TargetRoot)) {
    New-Item -ItemType Directory -Path $TargetRoot | Out-Null
}

Write-Host "Source: $SourceRoot"
Write-Host "Target: $TargetRoot"
Write-Log "Starting sync. DryRun=$($DryRun.IsPresent)"

# Exclusions (directories to ignore)
$ExcludeDirs = @('.git', '.DS_Store', '90-mcp-bootstrap')
$xdParams = $ExcludeDirs | ForEach-Object { "/XD `"$($_)`"" } | Out-String
$xdParams = $xdParams -replace "\r?\n"," "

# Robocopy args
$robocopyBase = "/MIR /R:2 /W:1 /NFL /NDL /NP /NJH /NJS"
if ($DryRun) {
    $robocopyArgs = "/L " + $xdParams + " " + $robocopyBase
} else {
    $robocopyArgs = $xdParams + " " + $robocopyBase
}

$cmd = "robocopy `"$SourceRoot`" `"$TargetRoot`" $robocopyArgs"
Write-Host $cmd
Write-Log "Running: $cmd"

Invoke-Expression $cmd
$rc = $LASTEXITCODE

Write-Log "Robocopy exit code: $rc"
if ($rc -gt 8) {
    Write-Host "Robocopy reported error (exit code $rc)" -ForegroundColor Red
    Write-Log "Robocopy failed with exit code $rc"
    exit $rc
}

# Ensure legacy dir removed in target (safety)
$legacy = Join-Path $TargetRoot '90-mcp-bootstrap'
if (Test-Path $legacy) {
    if ($DryRun) {
        Write-Host "[DryRun] Would remove legacy directory: $legacy" -ForegroundColor Yellow
        Write-Log "[DryRun] Would remove legacy directory: $legacy"
    } else {
        Write-Log "Removing legacy directory: $legacy"
        Remove-Item -Path $legacy -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Removed legacy directory: $legacy" -ForegroundColor Cyan
    }
}

# Post-check: compare file lists to detect remaining differences
$srcFiles = Get-ChildItem -Path $SourceRoot -Recurse -File | ForEach-Object { $_.FullName.Substring($SourceRoot.Length) } | Sort-Object
$dstFiles = Get-ChildItem -Path $TargetRoot -Recurse -File | ForEach-Object { $_.FullName.Substring($TargetRoot.Length) } | Sort-Object
$diff = Compare-Object -ReferenceObject $srcFiles -DifferenceObject $dstFiles
if ($diff) {
    Write-Host "Differences detected between source and target (non-empty). Review log: $Log" -ForegroundColor Yellow
    Write-Log "Differences detected: $($diff | Out-String)"
} else {
    Write-Host "Source and target are in sync." -ForegroundColor Green
    Write-Log "Source and target are in sync."
}

Write-Log "Sync completed."
