# Dotfiles

Personal dotfiles for a WSL development environment with Starship prompt, essential dev tools, AI CLI bootstrapping, and a backup of Claude Desktop MCP configuration.

## What's included

- **WSL / Zsh**: Shell configuration with Starship prompt, zoxide, fzf, mise, NVM, and zsh plugins
- **Starship**: Custom Gruvbox Dark theme prompt with programming language indicators
- **Claude Desktop**: MCP server configuration backup (Playwright, Shortcut, Chrome DevTools)
- **AI CLI setup**: Bootstraps Gemini CLI, Claude Code, Codex CLI, and Jules CLI via `setup.sh`

---

## Quick setup on a new machine

1. Clone the repo

```bash
git clone git@github.com:nparkison/dotfiles.git ~/.dotfiles
```

2. Run the setup script (this symlinks configs and installs AI CLIs)

```bash
cd ~/.dotfiles
chmod +x setup.sh
./setup.sh
```

This will symlink your configs, copy the Claude config (if applicable), and install core AI CLIs globally.

### Dependencies

Install these tools before running `setup.sh` (if not installed already):

- **Starship**

```bash
curl -sS https://starship.rs/install.sh | sh
```

- **zoxide**

```bash
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

- **fzf**

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

- **ripgrep** (used by fzf)

```bash
sudo apt install ripgrep
```

- **mise** (runtime version manager)

```bash
curl https://mise.run | sh
```

- **NVM** (Node Version Manager)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

- **zsh plugins** (autosuggestions and syntax-highlighting)

```bash
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
```

---

## File structure

```
~/.dotfiles/
├── zsh/
│   └── .zshrc                      # Shell config with aliases and tool initialization
├── starship/
│   └── starship.toml               # Gruvbox Dark theme prompt configuration
├── claude/
│   └── claude_desktop_config.json  # MCP server configuration backup
├── setup.sh                        # Bootstrap script (symlinks + AI CLIs)
└── READMEv2.md
```

---

## Key features

### Shell configuration

The `.zshrc` includes:

- **Auto-correction**: Typo correction for commands
- **Smart history**: 50k lines with timestamps, shared between sessions, deduplication
- **Key bindings**: Arrow keys for history search, Home/End navigation
- **Auto ls**: Automatically runs `ls -lh` after every `cd`
- **Enhanced globbing**: Extended glob patterns support

### Prompt and navigation

- **Starship**: Fast, customizable prompt with Gruvbox Dark color scheme
- **zoxide**: Smarter cd with frecency-based directory jumping (use `z`)
- **fzf**: Fuzzy finder for files (Ctrl+T) and command history (Ctrl+R)
  - Pre-configured to ignore `.git`, `node_modules`, `.venv`, `.mypy_cache`

### Development tools

- **mise**: Runtime version manager for Node.js, Python, Ruby, etc.
- **NVM**: Node Version Manager for managing Node.js versions
- **pnpm**: Fast, disk-space efficient package manager

### Zsh plugins

- **zsh-autosuggestions**: Fish-like autosuggestions based on history
- **zsh-syntax-highlighting**: Real-time syntax highlighting in the command line

### Custom aliases

**Git**

- `gs` → `git status -sb` (short branch format)
- `gp` → `git push`
- `gl` → `git log --oneline --graph --decorate -n 30`
- `gsync` → `~/bin/git-sync-gravel.sh`

**Navigation**

- `ll` → `ls -alF` (detailed list view)
- `..` / `...` → navigate up directories
- `p` → jump to `~/play`
- `w` → jump to `~/work`

**System**

- `open` → open current directory in Windows Explorer
- `update` → full system update (`sudo apt update && sudo apt upgrade && sudo apt autoremove`)

### Starship prompt features

The Gruvbox Dark theme includes:

- OS icon (󰕈 for Ubuntu)
- Username
- Current directory with icon substitutions
- Git branch and status
- Programming language versions (Node.js, Python, Rust, Go, etc.)
- Docker context
- Conda/Pixi environments
- Custom color scheme

### Claude Desktop MCP servers

Configured MCP servers:

- **Playwright**: Browser automation with screenshot output
- **Shortcut**: Project management integration
- **Chrome DevTools**: Chrome debugging tools

---

## Backup / restore Claude Desktop config

After making changes to Claude Desktop config, copy and commit the file to the repo:

```bash
cd ~/.dotfiles
cp /mnt/c/Users/$USER/AppData/Roaming/Claude/claude_desktop_config.json claude/
git add claude/claude_desktop_config.json
git commit -m "Update Claude Desktop config"
git push
```

Restore the Claude config on a new machine:

```bash
cp ~/.dotfiles/claude/claude_desktop_config.json /mnt/c/Users/$USER/AppData/Roaming/Claude/
```

---

## Maintaining your dotfiles

Since your configs are symlinked, edits to the live files keep the repo up to date.

1. Edit configs as normal:

```bash
nano ~/.zshrc
# or
code ~/.config/starship.toml
```

2. Commit changes:

```bash
cd ~/.dotfiles
git status
git add -A
git commit -m "Update configs"
git push
```

### Adding new configs

```bash
cd ~/.dotfiles
mkdir -p new-tool
cp ~/.config/some-config new-tool/
git add new-tool/
git commit -m "Add new-tool config"
git push

# Create symlink
ln -sf ~/.dotfiles/new-tool/some-config ~/.config/some-config
```

---

## Font recommendations

Install a Nerd Font for proper icon display in Starship:

- 3270 Nerd Font (recommended)
- FiraCode Nerd Font
- JetBrains Mono Nerd Font

Download from: https://www.nerdfonts.com/font-downloads

Configure in Windows Terminal:

Settings → Profiles → Ubuntu (WSL) → Appearance → Font face → Select your Nerd Font

---

## AI CLI tools setup

These are installed automatically by `setup.sh` (if configured):

- **Gemini CLI**

```bash
npm install -g @google/gemini-cli
gemini auth login
```

- **Claude Code**

```bash
npm install -g claude-code
claude login
```

- **Codex CLI**

```bash
pipx install codex-cli   # preferred
# or fallback
pip install --user codex-cli
codex auth login
```

- **Jules CLI**

```bash
npm install -g jules-cli
jules init
```

---

## Notes

- fzf ignores `.git`, `node_modules`, `.venv`, and `.mypy_cache`
- mise and NVM manage Node.js versions (both available)
- pnpm is configured via mise
- All tools initialize on shell startup for immediate availability
- Symlinks keep configs in sync with the repo automatically
- History is preserved across sessions with timestamps and deduplication
- Auto-suggestions and syntax highlighting enhance command-line experience
