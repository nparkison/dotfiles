###############################################
# ~/.zshrc — WSL + zsh + Oh My Posh (OMP)
###############################################

# -------- Shell basics --------
set -o noclobber
setopt HIST_IGNORE_SPACE share_history
export EDITOR="nano"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# -------- PATH (user-first) --------
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# -------- Prompt engine (Oh My Posh) --------
# eval "$(starship init zsh)"   # disabled to avoid conflicts

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/.dotfiles/oh-my-posh/agnoster.omp.json")"
else
  # Safe fallback prompt (no unclosed quotes)
  PROMPT='%F{yellow}[oh-my-posh missing]%f %n@%m %~ %# '
fi

# -------- Navigation & search tooling --------
# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# fzf sensible defaults
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules,.venv,.mypy_cache}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# fzf keybindings/history if available
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
[[ -f /usr/share/doc/fzf/examples/completion.zsh   ]] && source /usr/share/doc/fzf/examples/completion.zsh   2>/dev/null

# mise
[[ -x "$HOME/.local/bin/mise" ]] && eval "$("$HOME/.local/bin/mise" activate zsh)"

# pnpm PATH (deduped)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# -------- Aliases --------
alias ll='ls -alF'
alias gs='git status -sb'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -n 30'
alias ..='cd ..'; alias ...='cd ../..'
alias open='explorer.exe .'
alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

# Fast nav
alias p='cd ~/play'
alias w='cd ~/work'

# Glyph sanity check
alias glyphs=$'echo "\uE0B0 \uE0B1 \uE0B2 \uE0B3  NerdFont test ✓"'

# -------- Quality-of-life Zsh settings --------
autoload -Uz compinit; compinit -u
setopt AUTOCD autocd
setopt interactivecomments
bindkey -e

# -------- WSL-aware tweaks --------
export LESS="-R"
export PAGER="less -R"

# -------- One-shot bootstrap for a fresh WSL machine --------
bootstrap_wsl() {
  echo "[bootstrap] Updating apt and installing core CLI tools..."
  sudo apt update
  sudo apt install -y \
    ripgrep fzf zoxide git curl wget unzip \
    ca-certificates gnupg build-essential \
    bat fd-find

  # Symlink fd → fdfind if needed
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi

  # Install Oh My Posh
  if ! command -v oh-my-posh >/dev/null 2>&1; then
    echo "[bootstrap] Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
  fi

  echo "[bootstrap] Done. Reloading shell..."
  exec zsh
}

# -------- Optional: theme quick switcher --------
ompuse() {
  local cfg="${1:-$HOME/.dotfiles/oh-my-posh/agnoster.omp.json}"
  if [[ -f "$cfg" ]]; then
    export OMP_THEME="$cfg"
    eval "$(oh-my-posh init zsh --config "$OMP_THEME")"
    echo "[omp] using theme: $OMP_THEME"
  else
    echo "[omp] not found: $cfg" >&2
    return 1
  fi
}
