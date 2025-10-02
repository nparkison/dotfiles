# 1. Clone your dotfiles repo
git clone git@github.com:nparkison/dotfiles.git ~/.dotfiles

# 2. Backup any existing zshrc
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup.$(date +%s)

# 3. Symlink to the repo-managed config
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc

# 4. Run bootstrap (installs ripgrep, fzf, zoxide, OMP, etc.)
zsh -i -c bootstrap_wsl

Powershell
# 1. Clone your repo into Windows home
git clone git@github.com:nparkison/dotfiles.git $HOME\.dotfiles

# 2. Install Oh My Posh
winget install JanDeDobbeleer.OhMyPosh -s winget -e --accept-source-agreements --accept-package-agreements

# 3. Configure profile
$Dotfiles = "$HOME\.dotfiles\oh-my-posh\agnoster.omp.json"
$ProfileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $ProfileDir)) { New-Item -ItemType Directory -Path $ProfileDir | Out-Null }

if (Test-Path $PROFILE) {
  Copy-Item $PROFILE "$PROFILE.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
}

@"
oh-my-posh init pwsh --config `"$Dotfiles`" | Invoke-Expression
"@ | Set-Content -Encoding UTF8 $PROFILE


Install and set 3270 Nerd Font (or your chosen Nerd Font) in Windows Terminal → WSL profile. (Do this in all profiles if PS does not updated automatically)


## Claude Desktop
- Backup of Claude Desktop MCP config file
