# Homebrew management commands

# Install Homebrew for the current user
brew-install:
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed!"
        brew --version
    else
        echo "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        echo "Homebrew installation completed!"
        echo "Please restart your shell or run: source ~/.bashrc"
    fi

# Update Homebrew and upgrade all packages
brew-update:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v brew >/dev/null 2>&1; then
        echo "Error: Homebrew is not installed. Run 'just brew-install' first."
        exit 1
    fi
    echo "Updating Homebrew..."
    brew update
    echo "Upgrading installed packages..."
    brew upgrade
    echo "Cleaning up old versions..."
    brew cleanup
    echo "Homebrew update completed!"

# List installed Homebrew packages
brew-list:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v brew >/dev/null 2>&1; then
        echo "Error: Homebrew is not installed. Run 'just brew-install' first."
        exit 1
    fi
    brew list

# Show Homebrew information
brew-info:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is not installed."
        echo "To install, run: just brew-install"
    else
        brew --version
        echo ""
        echo "Homebrew prefix: $(brew --prefix)"
        echo "Installed packages: $(brew list | wc -l)"
    fi

# Clean up Homebrew cache and old versions
brew-cleanup:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v brew >/dev/null 2>&1; then
        echo "Error: Homebrew is not installed."
        exit 1
    fi
    echo "Cleaning up Homebrew..."
    brew cleanup -s
    brew autoremove
    echo "Cleanup completed!"
