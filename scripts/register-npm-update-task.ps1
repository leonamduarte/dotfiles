<#
  register-npm-update-task.ps1

  Creates a Windows Scheduled Task for update-npm-tools.ps1.

  Usage:
    .\register-npm-update-task.ps1 -At 09:00
    .\register-npm-update-task.ps1 -AtLogOn
    .\register-npm-update-task.ps1 -AtLogOn -TaskName "npm tool update at logon"
#>

param(
    [switch]$AtLogOn,
    [string]$At = '09:00',
    [string]$TaskName = 'npm daily update'
)

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$scriptPath = Join-Path $repoRoot 'scripts\update-npm-tools.ps1'

if (-not (Test-Path $scriptPath)) {
    throw "Update script not found: $scriptPath"
}

$action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

if ($AtLogOn) {
    $trigger = New-ScheduledTaskTrigger -AtLogOn
} else {
    $trigger = New-ScheduledTaskTrigger -Daily -At $At
}

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -RunLevel Highest | Out-Null
if ($AtLogOn) {
    Write-Host "Created scheduled task: $TaskName at logon"
} else {
    Write-Host "Created scheduled task: $TaskName at $At"
}
