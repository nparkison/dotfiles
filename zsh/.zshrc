# === WSL CORE ===
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# === ZSH OPTIONS ===
# Auto-correct typos
setopt CORRECT
setopt CORRECT_ALL

# Better globbing
setopt EXTENDED_GLOB

# === HISTORY CONFIGURATION ===
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write timestamp
setopt INC_APPEND_HISTORY        # Add immediately, not on exit
setopt SHARE_HISTORY             # Share between sessions
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_FIND_NO_DUPS         # Don't show duplicates in search
setopt HIST_REDUCE_BLANKS        # Remove extra blanks

# === AUTO LS AFTER CD ===
chpwd() { ls -lh }

# === KEY BINDINGS ===
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^[[H' beginning-of-line        # Home
bindkey '^[[F' end-of-line              # End

# === FZF ===
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules,.venv,.mypy_cache}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# === PATH ===
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# === ALIASES ===
alias ll='ls -alF'
alias gs='git status -sb'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -n 30'
alias gsync='~/bin/git-sync-gravel.sh'
alias ..='cd ..'; alias ...='cd ../..'
alias open='explorer.exe .'
alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

# Fast nav
alias p='cd ~/play'
alias w='cd ~/work'

# === MISE ===
eval "$(~/.local/bin/mise activate zsh)"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# === PNPM ===
export PNPM_HOME="/home/npark/.local/share/pnpm"
case ":$PATH:" in
  *"$PNPM_HOME":*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# === NVM ===
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# === ZSH PLUGINS (Load these last) ===
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
