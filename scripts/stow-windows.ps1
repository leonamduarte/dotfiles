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
            New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null
            Write-Host "  [link] $config -> $source" -ForegroundColor Cyan
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
        New-Item -ItemType SymbolicLink -Path $bashrcTarget -Target $bashrcSource | Out-Null
        Write-Host "  [link] .bashrc" -ForegroundColor Cyan
    }

    # .zshrc
    $zshrcTarget = Join-Path $HomeDir ".zshrc"
    $zshrcSource = Join-Path $DotfilesDir ".zshrc"
    if (Test-Path $zshrcTarget) {
        if (-not (Get-Item $zshrcTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .zshrc exists" -ForegroundColor Red
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $zshrcTarget -Target $zshrcSource | Out-Null
        Write-Host "  [link] .zshrc" -ForegroundColor Cyan
    }

    # .gemini
    $geminiTarget = Join-Path $HomeDir ".gemini"
    $geminiSource = Join-Path $DotfilesDir ".gemini"
    if (Test-Path $geminiTarget) {
        if (-not (Get-Item $geminiTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .gemini exists" -ForegroundColor Red
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $geminiTarget -Target $geminiSource | Out-Null
        Write-Host "  [link] .gemini" -ForegroundColor Cyan
    }

    # .agents
    $agentsTarget = Join-Path $HomeDir ".agents"
    $agentsSource = Join-Path $DotfilesDir "home\.agents"
    if (Test-Path $agentsTarget) {
        if (-not (Get-Item $agentsTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .agents exists" -ForegroundColor Red
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $agentsTarget -Target $agentsSource | Out-Null
        Write-Host "  [link] .agents" -ForegroundColor Cyan
    }

    # .codex
    $codexTarget = Join-Path $HomeDir ".codex"
    $codexSource = Join-Path $DotfilesDir "home\.codex"
    if (Test-Path $codexTarget) {
        if (-not (Get-Item $codexTarget).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "  [conflict] .codex exists" -ForegroundColor Red
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $codexTarget -Target $codexSource | Out-Null
        Write-Host "  [link] .codex" -ForegroundColor Cyan
    }

    Write-Host "Done!" -ForegroundColor Green
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
