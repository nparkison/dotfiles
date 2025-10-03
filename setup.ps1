# setup.ps1 - Windows host bootstrap (optional)
Write-Host "🚀 Windows bootstrap starting..." -ForegroundColor Cyan

# Ensure winget is present
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Warning "winget not found. Install App Installer from Microsoft Store first."
} else {
  # Core deps: Node, Python, Git
  winget install -e --id OpenJS.NodeJS.LTS -h || $true
  winget install -e --id Python.Python.3.12 -h || $true
  winget install -e --id Git.Git -h || $true
}

# npm globals (Gemini, Claude Code, Jules)
if (Get-Command npm -ErrorAction SilentlyContinue) {
  npm install -g @google/gemini-cli claude-code jules-cli
} else {
  Write-Warning "npm not found—install NodeJS first."
}

# pipx for Python CLIs
if (-not (Get-Command pipx -ErrorAction SilentlyContinue)) {
  python -m pip install --user pipx
  python -m pipx ensurepath
}
pipx install codex-cli

Write-Host "✓ Windows bootstrap complete." -ForegroundColor Green
