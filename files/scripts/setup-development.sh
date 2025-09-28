#!/usr/bin/env bash

# Development Tools Setup Script
# Installs Claude Code CLI and Zed editor

set -oue pipefail

echo "Setting up development tools..."

# =============================================================================
# CLAUDE CODE CLI INSTALLATION
# =============================================================================

echo "Installing Claude Code CLI..."

# Install Claude Code globally via npm
npm install -g @anthropic-ai/claude-code

# Verify installation
if command -v claude-code &> /dev/null; then
    echo "Claude Code CLI installed successfully"
else
    echo "Warning: Claude Code CLI installation may have failed"
fi

# =============================================================================
# ZED EDITOR INSTALLATION
# =============================================================================

echo "Installing Zed editor..."

# Create temporary directory for Zed installation
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and install Zed using the official installation script
curl -fsSL https://zed.dev/install.sh | bash

# Move Zed to system location if installed in user directory
if [ -f "$HOME/.local/bin/zed" ]; then
    mkdir -p /usr/local/bin
    cp "$HOME/.local/bin/zed" /usr/local/bin/zed
    chmod +x /usr/local/bin/zed
    echo "Zed editor installed to /usr/local/bin/zed"
elif command -v zed &> /dev/null; then
    echo "Zed editor installed successfully"
else
    echo "Warning: Zed editor installation may have failed"
fi

# Clean up
cd /
rm -rf "$TEMP_DIR"

# =============================================================================
# SETUP COMPLETION
# =============================================================================

echo "Development tools setup completed!"
echo "Available editors:"
echo "  - zed (Zed editor)"
echo "  - claude-code (Claude Code CLI)"
echo "  - micro (terminal editor)"