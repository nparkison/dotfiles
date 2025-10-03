#!/usr/bin/env bash
set -euo pipefail

log() { printf "\033[1;36m%s\033[0m\n" "▸ $*"; }
warn() { printf "\033[1;33m%s\033[0m\n" "⚠ $*"; }
ok() { printf "\033[1;32m%s\033[0m\n" "✓ $*"; }

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log "🚀 Setting up dotfiles..."

# ----------------------------
# 0) Sanity / environment info
# ----------------------------
if ! command -v zsh >/dev/null 2>&1; then
  warn "zsh not found. Install zsh first (e.g., sudo apt update && sudo apt install -y zsh)."
else
  ok "zsh found: $(zsh --version | head -n1)"
fi

# Detect WSL + derive Windows user profile path for Claude config
IS_WSL=0
if grep -qi microsoft /proc/version 2>/dev/null; then
  IS_WSL=1
fi

WIN_USER="${USER}"
if [ "${IS_WSL}" -eq 1 ]; then
  # Try to infer Windows username from mounted C: drive path
  if [ -d "/mnt/c/Users/${USER}" ]; then
    WIN_USER="${USER}"
  else
    # Fallback: pick first user dir with Desktop present
    CANDIDATE=$(ls /mnt/c/Users 2>/dev/null | head -n1 || true)
    if [ -n "${CANDIDATE:-}" ]; then WIN_USER="$CANDIDATE"; fi
  fi
fi

# ----------------------------
# 1) Link Shell Configs (zsh!)
# ----------------------------
log "Linking shell configs..."
mkdir -p "${HOME}"
if [ -f "${REPO_ROOT}/wsl/.zshrc" ]; then
  ln -sf "${REPO_ROOT}/wsl/.zshrc" "${HOME}/.zshrc"
  ok "Linked ~/.zshrc"
fi
# Keep bashrc as a backup / compatibility layer
if [ -f "${REPO_ROOT}/wsl/.bashrc" ]; then
  ln -sf "${REPO_ROOT}/wsl/.bashrc" "${HOME}/.bashrc"
  ok "Linked ~/.bashrc"
fi

# ----------------------------
# 2) Starship + other configs
# ----------------------------
log "Linking Starship and other config files..."
mkdir -p "${HOME}/.config"

# Starship
if [ -f "${REPO_ROOT}/starship/starship.toml" ]; then
  ln -sf "${REPO_ROOT}/starship/starship.toml" "${HOME}/.config/starship.toml"
  ok "Linked ~/.config/starship.toml"
fi

# Add more configs as your repo grows (examples):
# if [ -d "${REPO_ROOT}/zsh" ]; then
#   ln -sf "${REPO_ROOT}/zsh" "${HOME}/.config/zsh"
#   ok "Linked ~/.config/zsh -> repo/zsh"
# fi

# Ensure Starship initialization lines exist (idempotent)
if command -v starship >/dev/null 2>&1; then
  if ! grep -q 'starship init zsh' "${HOME}/.zshrc"; then
    {
      echo ''
      echo '# --- starship init (managed by setup.sh) ---'
      echo 'export STARSHIP_CONFIG="$HOME/.config/starship.toml"'
      echo 'eval "$(starship init zsh)"'
    } >> "${HOME}/.zshrc"
    ok "Appended Starship init to ~/.zshrc"
  fi
else
  warn "starship not found. Install via: curl -sS https://starship.rs/install.sh | sh"
fi

# --------------------------------
# 3) Claude Desktop config (WSL)
# --------------------------------
if [ "${IS_WSL}" -eq 1 ]; then
  CLAUDE_WIN_DIR="/mnt/c/Users/${WIN_USER}/AppData/Roaming/Claude"
  if [ -d "${CLAUDE_WIN_DIR}" ]; then
    log "Setting up Claude Desktop config..."
    # Optional: run your repo script if it exists
    if [ -x "${REPO_ROOT}/claude/install.sh" ]; then
      bash "${REPO_ROOT}/claude/install.sh"
      ok "Ran claude/install.sh"
    fi

    # If you keep a tracked copy in repo/claude/, link or copy as desired:
    if [ -f "${REPO_ROOT}/claude/claude_desktop_config.json" ]; then
      cp -f "${REPO_ROOT}/claude/claude_desktop_config.json" "${CLAUDE_WIN_DIR}/claude_desktop_config.json"
      ok "Copied Claude config to Windows Roaming dir"
    else
      warn "No repo/claude/claude_desktop_config.json found to copy."
    fi
  else
    warn "Claude roaming dir not found at ${CLAUDE_WIN_DIR}. Is Claude Desktop installed on Windows?"
  fi
fi

# --------------------------------
# 4) AI CLI Tooling
# --------------------------------
log "Installing AI CLIs (idempotent)..."

# Node-based CLIs
if command -v npm >/dev/null 2>&1; then
  npm list -g --depth=0 >/dev/null 2>&1 || true
  # Group install to minimize prompts
  NPM_PKGS=( "@google/gemini-cli" "claude-code" "jules-cli" )
  for pkg in "${NPM_PKGS[@]}"; do
    if ! npm list -g --depth=0 2>/dev/null | grep -qi "${pkg}@"; then
      log "npm -g install ${pkg}"
      npm install -g "${pkg}"
      ok "Installed ${pkg}"
    else
      ok "${pkg} already installed"
    fi
  done
else
  warn "npm not found. Install Node.js (e.g., via mise or nvm) then re-run setup."
fi

# Python-based CLIs via pipx (preferred)
if command -v pipx >/dev/null 2>&1; then
  if ! pipx list 2>/dev/null | grep -qi 'codex-cli'; then
    log "pipx install codex-cli"
    pipx install codex-cli
    ok "Installed codex-cli via pipx"
  else
    ok "codex-cli already installed (pipx)"
  fi
else
  warn "pipx not found; falling back to pip --user for codex-cli"
  if command -v python3 >/dev/null 2>&1; then
    if ! python3 -m pip show --user codex-cli >/dev/null 2>&1; then
      python3 -m pip install --user codex-cli
      ok "Installed codex-cli with pip --user"
      warn "Consider installing pipx for isolated Python CLIs: python3 -m pip install --user pipx && python3 -m pipx ensurepath"
    else
      ok "codex-cli already installed (pip --user)"
    fi
  else
    warn "Python3 not found; skipping codex-cli."
  fi
fi

# Optional first-time auth stubs (commented so it’s non-blocking)
# gemini auth login
# claude login
# jules init

# --------------------------------
# 5) Verification
# --------------------------------
log "Verifying installs..."
for cmd in zsh starship gemini claude jules codex; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    ok "$(printf '%-6s' "${cmd}") -> $(command -v "${cmd}")"
  else
    warn "Missing: ${cmd}"
  fi
done

ok "✨ Setup complete!"

