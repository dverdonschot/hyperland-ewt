#!/usr/bin/env bash

# System Configuration Setup
# Creates GDM/XDG session files and environment variables

set -oue pipefail

echo "Setting up system configuration..."

# =============================================================================
# SYSTEM CONFIGURATION
# =============================================================================

# Create GDM session file for Hyprland
cat > /usr/share/wayland-sessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=hyprland
Type=Application
DesktopNames=Hyprland
EOF

# Create XDG session file
cat > /usr/share/xsessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=hyprland
Type=Application
DesktopNames=Hyprland
EOF

# =============================================================================
# ENVIRONMENT SETUP
# =============================================================================

# Add Hyprland environment variables to system profile
cat > /etc/profile.d/hyprland.sh << 'EOF'
# Hyprland environment variables
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland

# Qt applications
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# GTK applications
export GDK_BACKEND=wayland,x11

# Mozilla applications
export MOZ_ENABLE_WAYLAND=1

# Cursor settings
export XCURSOR_SIZE=24
export XCURSOR_THEME=Adwaita

# SDL applications
export SDL_VIDEODRIVER=wayland

# Java applications
export _JAVA_AWT_WM_NONREPARENTING=1
EOF

echo "System configuration setup completed!"