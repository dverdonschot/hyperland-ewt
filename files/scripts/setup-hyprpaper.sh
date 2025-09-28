#!/usr/bin/env bash

# Hyprpaper Configuration Setup
# Creates hyprpaper wallpaper configuration

set -oue pipefail

echo "Setting up Hyprpaper configuration..."

# =============================================================================
# HYPRPAPER CONFIGURATION
# =============================================================================

mkdir -p /etc/skel/.config/hypr

cat > /etc/skel/.config/hypr/hyprpaper.conf << 'EOF'
preload = /usr/share/backgrounds/nature-mountains.jpg
wallpaper = , /usr/share/backgrounds/nature-mountains.jpg
splash = false
EOF

echo "Hyprpaper configuration setup completed!"