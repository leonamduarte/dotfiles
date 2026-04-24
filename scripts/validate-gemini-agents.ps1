# Validate Gemini agent files in home/.agents/gemini/agents/
# Checks: frontmatter exists, required keys present, model is valid.

$ErrorActionPreference = "Stop"

$agentsDir = Join-Path $PSScriptRoot ".." "home" ".agents" "gemini" "agents"
$validModels = @("gemini-2.0-flash", "gemini-2.0-mini")
$requiredKeys = @("name", "description", "model", "tools")
$errors = 0
$checked = 0

if (-not (Test-Path $agentsDir)) {
    Write-Error "Agents directory not found: $agentsDir"
    exit 1
}

$files = Get-ChildItem -Path $agentsDir -Filter "*.md"
if ($files.Count -eq 0) {
    Write-Error "No .md files found in $agentsDir"
    exit 1
}

foreach ($file in $files) {
    $checked++
    $content = Get-Content $file -Raw

    # Check frontmatter delimiters
    if ($content -notmatch "^---\r?\n") {
        Write-Warning "$($file.Name): missing frontmatter opening ---"
        $errors++
        continue
    }

    # Extract frontmatter block
    $fmMatch = [regex]::Match($content, "^---\r?\n(.*?)\r?\n---", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $fmMatch.Success) {
        Write-Warning "$($file.Name): malformed frontmatter (no closing ---)"
        $errors++
        continue
    }

    $fm = $fmMatch.Groups[1].Value

    foreach ($key in $requiredKeys) {
        if ($fm -notmatch "(?m)^$key\s*:") {
            Write-Warning "$($file.Name): missing required key '$key'"
            $errors++
        }
    }

    # Validate model value
    $modelMatch = [regex]::Match($fm, "(?m)^model\s*:\s*(.+)$")
    if ($modelMatch.Success) {
        $model = $modelMatch.Groups[1].Value.Trim()
        if ($model -notin $validModels) {
            Write-Warning "$($file.Name): unknown model '$model' (expected: $($validModels -join ', '))"
            $errors++
        }
    }
}

Write-Host "Checked $checked agent file(s), $errors issue(s) found."
if ($errors -gt 0) { exit 1 }
exit 0
