# Backup known conflicting files in HOME and run stow to recreate links
param()

$Home = $env:USERPROFILE
$Items = @('.bashrc', '.zshrc', '.gemini', '.codex')
$ts = Get-Date -Format 'yyyyMMddHHmmss'

foreach ($item in $Items) {
    $path = Join-Path $Home $item
    if (Test-Path $path) {
        try {
            $itm = Get-Item -LiteralPath $path -Force
        } catch {
            $msg = $_.Exception.Message -replace '"','\"'
            Write-Host ("[error] Could not inspect {0}: {1}" -f $path, $msg) -ForegroundColor Red
            continue
        }

        if ($itm.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Write-Host "[skip] $path is already a symlink/junction"
            continue
        }

        $bak = "$path.backup-$ts"
        try {
            Move-Item -LiteralPath $path -Destination $bak -Force
            Write-Host ("[backup] Moved {0} -> {1}" -f $path, $bak)
        } catch {
            $msg = $_.Exception.Message -replace '"','\"'
            Write-Host ("[error] Failed to move {0}: {1}" -f $path, $msg) -ForegroundColor Red
        }
    } else {
        Write-Host ("[notfound] {0} does not exist" -f $path)
    }
}

# Now run stow to create links (expects to be run from repo root)
Write-Host "Running stow to create links..."
& "$PSScriptRoot\stow-windows.ps1" -Action stow
