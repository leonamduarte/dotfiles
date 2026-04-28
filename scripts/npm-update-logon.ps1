<#
  npm-update-logon.ps1

  Shortcut wrapper to create the elevated logon task in one command.

  Usage:
    .\scripts\npm-update-logon.ps1
#>

$ErrorActionPreference = 'Stop'

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    throw 'Run this script in an elevated PowerShell session (Run as Administrator).'
}

& (Join-Path $PSScriptRoot 'register-npm-update-task.ps1') -AtLogOn -TaskName 'npm tool update at logon'
