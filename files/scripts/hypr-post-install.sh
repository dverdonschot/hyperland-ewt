#!/usr/bin/env bash

# Hyprland Post-Installation Setup Script
# Configures Hyprland environment and sets up user configurations

set -oue pipefail

echo "Starting Hyprland post-installation setup..."

# Get the directory where this script is located
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# =============================================================================
# MODULAR SETUP EXECUTION
# =============================================================================

# Execute each setup module
echo "Running system configuration setup..."
bash "${SCRIPT_DIR}/setup-system.sh"

echo "Running Waybar configuration setup..."
bash "${SCRIPT_DIR}/setup-waybar.sh"

echo "Running Hyprpaper configuration setup..."
bash "${SCRIPT_DIR}/setup-hyprpaper.sh"

echo "Running Rofi configuration setup..."
bash "${SCRIPT_DIR}/setup-rofi.sh"

echo "Running shell configuration setup..."
bash "${SCRIPT_DIR}/setup-shell.sh"

echo "Running Tmux configuration setup..."
bash "${SCRIPT_DIR}/setup-tmux.sh"

echo "Running Homebrew configuration setup..."
bash "${SCRIPT_DIR}/setup-homebrew.sh"

echo "Running development tools setup..."
bash "${SCRIPT_DIR}/setup-development.sh"

# =============================================================================
# ENABLE SERVICES
# =============================================================================

echo "Enabling system services..."

# Enable GDM if not already enabled
systemctl enable gdm.service

echo "Hyprland post-installation setup completed successfully!"
echo "Users will need to log out and select Hyprland from the session menu."