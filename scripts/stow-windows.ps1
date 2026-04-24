# Dotfiles Symlink Manager for Windows
# Usage: .\scripts\stow-windows.ps1 [-Action "stow"|"unstow"]

param(
    [string]$Action = "stow"
)

$DotfilesDir = "$PSScriptRoot\.."
$HomeDir = $env:USERPROFILE

$Configs = @(
    "alacritty",
    "autostart",
    "doom",
    "fish",
    "ghostty",
    "hypr",
    "kitty",
    "nvim",
    "opencode",
    "wezterm",
    "yazi"
)

function Stow-Dotfiles {
    Write-Host "Creating symlinks..." -ForegroundColor Green

    foreach ($config in $Configs) {
        $target = Join-Path $HomeDir ".config\$config"
        $source = Join-Path $DotfilesDir "config\.config\$config"

        if (Test-Path $target) {
            if ((Get-Item $target).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
                Write-Host "  [skip] $config (already linked)" -ForegroundColor Yellow
            } else {
                Write-Host "  [conflict] $target exists as directory" -ForegroundColor Red
            }
        } else {
            TryCreateLink -LinkPath $target -TargetPath $source -IsDirectory $true
        }
    }

    # .bashrc
    $bashrcTarget = Join-Path $HomeDir ".bashrc"
    $bashrcSource = Join-Path $DotfilesDir ".bashrc"
    if (Test-Path $bashrcTarget) {
        if (-not (Get-Item $bashrcTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .bashrc exists" -ForegroundColor Red
        }
    } else {
        TryCreateLink -LinkPath $bashrcTarget -TargetPath $bashrcSource -IsDirectory $false
    }

    # .zshrc
    $zshrcTarget = Join-Path $HomeDir ".zshrc"
    $zshrcSource = Join-Path $DotfilesDir ".zshrc"
    if (Test-Path $zshrcTarget) {
        if (-not (Get-Item $zshrcTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .zshrc exists" -ForegroundColor Red
        }
    } else {
        TryCreateLink -LinkPath $zshrcTarget -TargetPath $zshrcSource -IsDirectory $false
    }

    # PowerShell profiles
    $psProfileSource = Join-Path $DotfilesDir "config\.config\powershell\Microsoft.PowerShell_profile.ps1"
    @(
        (Join-Path ([Environment]::GetFolderPath('MyDocuments')) "PowerShell\Microsoft.PowerShell_profile.ps1"),
        (Join-Path ([Environment]::GetFolderPath('MyDocuments')) "WindowsPowerShell\Microsoft.PowerShell_profile.ps1")
    ) | ForEach-Object {
        $psProfileTarget = $_
        $psProfileDir = Split-Path $psProfileTarget -Parent

        if (-not (Test-Path $psProfileDir)) {
            New-Item -ItemType Directory -Path $psProfileDir -Force | Out-Null
        }

        if (Test-Path $psProfileTarget) {
            if (-not (Get-Item $psProfileTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
                Write-Host "  [conflict] $psProfileTarget exists" -ForegroundColor Red
            }
        } else {
            TryCreateLink -LinkPath $psProfileTarget -TargetPath $psProfileSource -IsDirectory $false
        }
    }

    # .gemini
    $geminiTarget = Join-Path $HomeDir ".gemini"
    $geminiSource = Join-Path $DotfilesDir ".gemini"
    if (Test-Path $geminiTarget) {
        if (-not (Get-Item $geminiTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .gemini exists" -ForegroundColor Red
        }
    } else {
        TryCreateLink -LinkPath $geminiTarget -TargetPath $geminiSource -IsDirectory $true
    }

    # .agents
    $agentsTarget = Join-Path $HomeDir ".agents"
    $agentsSource = Join-Path $DotfilesDir "home\.agents"
    if (Test-Path $agentsTarget) {
        if (-not (Get-Item $agentsTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .agents exists" -ForegroundColor Red
        }
    } else {
        TryCreateLink -LinkPath $agentsTarget -TargetPath $agentsSource -IsDirectory $true
    }

    # .codex
    $codexTarget = Join-Path $HomeDir ".codex"
    $codexSource = Join-Path $DotfilesDir "home\.codex"
    if (Test-Path $codexTarget) {
        if (-not (Get-Item $codexTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .codex exists" -ForegroundColor Red
        }
    } else {
        TryCreateLink -LinkPath $codexTarget -TargetPath $codexSource -IsDirectory $true
    }

    Write-Host "Done!" -ForegroundColor Green
}

# Helper: try to create a symlink, fallback to junction for directories or copy for files
function TryCreateLink {
    param(
        [Parameter(Mandatory=$true)] [string]$LinkPath,
        [Parameter(Mandatory=$true)] [string]$TargetPath,
        [Parameter(Mandatory=$true)] [bool]$IsDirectory
    )

    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath -Force | Out-Null
        Write-Host "  [link] $LinkPath -> $TargetPath" -ForegroundColor Cyan
        return
    } catch {
        Write-Host "  [warn] Could not create symbolic link: $($_.Exception.Message)" -ForegroundColor Yellow
    }

    if ($IsDirectory) {
        try {
            # attempt a junction as fallback
            New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
            Write-Host "  [junction] $LinkPath -> $TargetPath" -ForegroundColor Cyan
            return
        } catch {
            Write-Host "  [error] Failed to create junction: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        try {
            Copy-Item -Path $TargetPath -Destination $LinkPath -Force
            Write-Host "  [copy] $LinkPath (file copied as fallback)" -ForegroundColor Cyan
            return
        } catch {
            Write-Host "  [error] Failed to copy file fallback: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "  [fail] Could not create link or fallback for $LinkPath" -ForegroundColor Red
}

function Unstow-Dotfiles {
    Write-Host "Removing symlinks..." -ForegroundColor Green

    foreach ($config in $Configs) {
        $target = Join-Path $HomeDir ".config\$config"
        if (Test-Path $target) {
            if ((Get-Item $target).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
                Remove-Item $target -Force
                Write-Host "  [remove] $config" -ForegroundColor Cyan
            } else {
                Write-Host "  [skip] $config (not a symlink)" -ForegroundColor Yellow
            }
        }
    }

    @(".bashrc", ".zshrc", ".gemini", ".agents", ".codex") | ForEach-Object {
        $target = Join-Path $HomeDir $_
        if (Test-Path $target) {
            if ((Get-Item $target).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
                Remove-Item $target -Force
                Write-Host "  [remove] $_" -ForegroundColor Cyan
            }
        }
    }

    Write-Host "Done!" -ForegroundColor Green
}

switch ($Action) {
    "stow" { Stow-Dotfiles }
    "unstow" { Unstow-Dotfiles }
    default { Write-Host "Usage: .\stow-windows.ps1 [-Action stow|unstow]" -ForegroundColor Red }
}
