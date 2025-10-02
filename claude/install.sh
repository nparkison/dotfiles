#!/bin/bash
# Link Claude config
CLAUDE_DIR="/mnt/c/Users/$USER/AppData/Roaming/Claude"
mkdir -p "$CLAUDE_DIR"
ln -sf "$(pwd)/claude_desktop_config.json" "$CLAUDE_DIR/claude_desktop_config.json"
echo "✓ Claude config linked"
