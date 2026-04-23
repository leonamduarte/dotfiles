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

    @(".bashrc", ".zshrc") | ForEach-Object {
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
