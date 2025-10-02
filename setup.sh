#!/bin/bash

echo "🚀 Setting up dotfiles..."

# WSL configs
echo "Linking WSL configs..."
ln -sf $(pwd)/wsl/.bashrc ~/.bashrc
ln -sf $(pwd)/wsl/.zshrc ~/.zshrc

# Claude config
echo "Setting up Claude Desktop config..."
bash claude/install.sh

echo "✨ Setup complete!"
