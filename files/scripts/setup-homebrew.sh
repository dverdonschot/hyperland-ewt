#!/usr/bin/env bash

# Homebrew Installation Setup
# Installs Homebrew and configures shell environment

set -oue pipefail

echo "Setting up Homebrew installation..."

# =============================================================================
# HOMEBREW INSTALLATION
# =============================================================================

# Create homebrew installation script for users
cat > /etc/skel/.install-homebrew.sh << 'EOF'
#!/usr/bin/env bash

# Homebrew installation script for new users
# This script will be available in each user's home directory

set -e

echo "Installing Homebrew..."

# Check if Homebrew is already installed
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed!"
    brew --version
    exit 0
fi

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to current shell session
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "Homebrew installation completed!"
echo "Please restart your shell or run: source ~/.bashrc"
EOF

# Make the install script executable
chmod +x /etc/skel/.install-homebrew.sh

# =============================================================================
# SHELL ENVIRONMENT CONFIGURATION
# =============================================================================

# Add Homebrew environment setup to bashrc template
cat >> /etc/skel/.bashrc << 'EOF'

# Homebrew environment setup
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -d "$HOME/.linuxbrew" ]]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
fi
EOF

# Add information script about Homebrew
cat > /usr/bin/hypr-install-homebrew << 'EOF'
#!/usr/bin/env bash

# System-wide Homebrew installation helper
# Provides instructions and installation for Homebrew

set -e

echo "==============================================="
echo "Homebrew Installation Helper"
echo "==============================================="
echo ""
echo "Homebrew provides access to CLI tools that aren't"
echo "available as Flatpaks or system packages."
echo ""
echo "Examples: htop, exa, fzf, zoxide, bat, ripgrep"
echo ""

if command -v brew >/dev/null 2>&1; then
    echo "✅ Homebrew is already installed!"
    echo "Version: $(brew --version | head -1)"
    echo ""
    echo "Update with: brew update && brew upgrade"
    echo "Install packages with: brew install <package>"
else
    echo "❌ Homebrew is not installed."
    echo ""
    echo "To install Homebrew, run:"
    echo "  ~/.install-homebrew.sh"
    echo ""
    echo "Or install manually:"
    echo "  NONINTERACTIVE=1 /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo ""
    echo "After installation, restart your shell or run:"
    echo "  source ~/.bashrc"
fi

echo ""
echo "Homebrew will install to: /home/linuxbrew/.linuxbrew"
echo "This location is safe for immutable systems like Silverblue."
echo "==============================================="
EOF

# Make the helper script executable
chmod +x /usr/bin/hypr-install-homebrew

# =============================================================================
# SYSTEM DEPENDENCIES
# =============================================================================

# Install essential development tools that Homebrew may need
# These are overlayed onto the system image during build

echo "Note: Development tools for Homebrew are available via:"
echo "  rpm-ostree install gcc gcc-c++ make"
echo "  (or use toolbox/distrobox for containerized development)"

echo "Homebrew configuration setup completed!"
echo "Users can install Homebrew by running: ~/.install-homebrew.sh"
echo "Or get help with: hypr-install-homebrew"