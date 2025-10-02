# Dotfiles

Personal dotfiles for WSL development environment with Starship prompt, essential dev tools, and Claude Desktop MCP configuration backup.

## What's Included

- **WSL/Zsh**: Shell configuration with Starship prompt, Zoxide, fzf, and mise
- **Starship**: Custom Gruvbox Dark theme prompt with programming language indicators
- **Claude Desktop**: MCP server configuration backup (Playwright, Shortcut, Chrome DevTools)

## Quick Setup on New Machine
```bash
# 1. Clone the repo
git clone git@github.com:nparkison/dotfiles.git ~/.dotfiles

# 2. Install dependencies first (see Dependencies section below)

# 3. Create symlinks
rm ~/.zshrc ~/.config/starship.toml  # Remove existing files
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

# 4. Reload shell
exec zsh

# 5. Restore Claude Desktop config (optional)
cp ~/.dotfiles/claude/claude_desktop_config.json /mnt/c/Users/$USER/AppData/Roaming/Claude/

## Dependencies

Install these tools before setting up dotfiles:

### Starship
```bash
curl -sS https://starship.rs/install.sh | sh

## Zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

## fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

## ripgref (for fzf)
sudo apt install ripgrep

## mise (runtime version manager)
curl https://mise.run | sh

## File Structure
~/.dotfiles/
├── zsh/
│   └── .zshrc              # Shell config with aliases and tool initialization
├── starship/
│   └── starship.toml       # Gruvbox Dark theme prompt configuration
├── claude/
│   └── claude_desktop_config.json  # MCP server configuration
└── README.md

## Key Features
### Prompt and Nav
- Starship: Fast, customizable prompt with Gruvbox Dark color scheme
- Zoxide: Smarter cd with frecency-based directory jumping (use z command)
- fzf: Fuzzy finder for files (Ctrl+T) and command history (Ctrl+R)

## Development Tools
- mise: Runtime version manager for Node.js, Python, Ruby, etc.
- pnpm: Fast, disk space efficient package manager

## Custom Aliases
Git:
- gs (git status)
- gp (git push)
- gl (git log)

## Navigation
- ll - Detailed list view
- .. / ... - Navigate up directories
- p - Jump to ~/play
- w - Jump to ~/work

## System
- open - Open current directory in Windows Explorer
- update - Full system update (apt update + upgrade + autoremove)

# Starship Prompt Features

The Gruvbox Dark theme includes:

- OS icon (󰕈 for Ubuntu)  
- Username  
- Current directory with icon substitutions  
- Git branch and status  
- Programming language versions (Node.js, Python, Rust, Go, etc.)  
- Docker context  
- Conda/Pixi environments  
- Custom color scheme  

---

# Claude Desktop MCP Servers

Configured MCP servers:

- **Playwright**: Browser automation with screenshot output  
- **Shortcut**: Project management integration  
- **Chrome DevTools**: Chrome debugging tools  

---

# Backup Claude Config

```bash
# After making changes to Claude Desktop config
cd ~/.dotfiles
cp /mnt/c/Users/$USER/AppData/Roaming/Claude/claude_desktop_config.json claude/
git add claude/claude_desktop_config.json
git commit -m "Update Claude Desktop config"
git push

## Restore Claude Config on new machine
cp ~/.dotfiles/claude/claude_desktop_config.json /mnt/c/Users/$USER/AppData/Roaming/Claude/

## Maintaining your dotfiles - Configs are symlinked
# 1. Edit configs as normal
nano ~/.zshrc
# or
code ~/.config/starship.toml

# 2. Changes are already in ~/.dotfiles, just commit
cd ~/.dotfiles
git status
git add -A
git commit -m "Update configs"
git push

## Adding new configs to dotfiles
cd ~/.dotfiles
mkdir -p new-tool
cp ~/.config/some-config new-tool/
git add new-tool/
git commit -m "Add new-tool config"
git push

# Create symlink
ln -sf ~/.dotfiles/new-tool/some-config ~/.config/some-config

## Font recs
- 3270 Nerd Font
- Firacode Nerd Font
- JetBrains Mono Nerd Font
- Download from: https://www.nerdfonts.com/font-downloads


