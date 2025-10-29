#!/usr/bin/env bash

# Shell Configuration Setup
# Sets up oh-my-posh and other shell enhancements

set -oue pipefail

echo "Setting up shell configuration..."

# =============================================================================
# SHELL CONFIGURATION
# =============================================================================

# Setup oh-my-posh for new users
mkdir -p /etc/skel/.config/oh-my-posh

# Download the custom oh-my-posh theme
curl -s https://raw.githubusercontent.com/dverdonschot/nixos-systems-configuration/main/config/posh-dverdonschot.omp.json -o /etc/skel/.config/oh-my-posh/theme.json

# Add oh-my-posh initialization and npm PATH to bashrc template
cat >> /etc/skel/.bashrc << 'EOF'

# NPM global packages path
export PATH="$HOME/.npm-global/bin:$PATH"

# Oh My Posh initialization
if command -v oh-my-posh >/dev/null 2>&1; then
    eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/theme.json)"
fi
EOF

echo "Shell configuration setup completed!"