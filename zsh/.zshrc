# === WSL CORE ===
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# fzf sensible defaults
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules,.venv,.mypy_cache}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# Aliases
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
# mise
eval "$(~/.local/bin/mise activate zsh)"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# pnpm
export PNPM_HOME="/home/npark/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
