#!/usr/bin/env bash

# Hyprland Post-Installation Setup Script
# Configures Hyprland environment and sets up user configurations

set -oue pipefail

echo "Starting Hyprland post-installation setup..."

# =============================================================================
# SYSTEM CONFIGURATION
# =============================================================================

# Create GDM session file for Hyprland
cat > /usr/share/wayland-sessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
EOF

# Create XDG session file
cat > /usr/share/xsessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
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

# =============================================================================
# WAYBAR CONFIGURATION
# =============================================================================

# Create system-wide waybar configuration directory
mkdir -p /etc/skel/.config/waybar

# Basic waybar configuration
cat > /etc/skel/.config/waybar/config << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 35,
    "spacing": 5,
    "modules-left": ["hyprland/workspaces", "hyprland/mode"],
    "modules-center": ["clock"],
    "modules-right": ["idle_inhibitor", "pulseaudio", "network", "battery", "tray"],
    
    "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
            "1": "󰈹",
            "2": "",
            "3": "",
            "4": "",
            "5": "",
            "urgent": "",
            "focused": "",
            "default": ""
        }
    },
    
    "clock": {
        "format": "{:%Y-%m-%d %H:%M}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format-alt": "{:%Y-%m-%d}"
    },
    
    "battery": {
        "states": {
            "good": 95,
            "warning": 30,
            "critical": 15
        },
        "format": "{capacity}% {icon}",
        "format-charging": "{capacity}% ",
        "format-plugged": "{capacity}% ",
        "format-alt": "{time} {icon}",
        "format-icons": ["", "", "", "", ""]
    },
    
    "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "tooltip-format": "{ifname} via {gwaddr} ",
        "format-linked": "{ifname} (No IP) ",
        "format-disconnected": "Disconnected ⚠",
        "format-alt": "{ifname}: {ipaddr}/{cidr}"
    },
    
    "pulseaudio": {
        "format": "{volume}% {icon} {format_source}",
        "format-bluetooth": "{volume}% {icon} {format_source}",
        "format-bluetooth-muted": " {icon} {format_source}",
        "format-muted": " {format_source}",
        "format-source": "{volume}% ",
        "format-source-muted": "",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
    },
    
    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": "",
            "deactivated": ""
        }
    },
    
    "tray": {
        "icon-size": 21,
        "spacing": 10
    }
}
EOF

# Waybar stylesheet
cat > /etc/skel/.config/waybar/style.css << 'EOF'
* {
    border: none;
    border-radius: 0;
    font-family: "Inter", "Font Awesome 6 Free";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: rgba(30, 30, 46, 0.9);
    border-bottom: 2px solid rgba(51, 204, 255, 0.8);
    color: #cdd6f4;
    transition-property: background-color;
    transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.2;
}

#workspaces button {
    padding: 0 8px;
    background-color: transparent;
    color: #bac2de;
    border-bottom: 2px solid transparent;
}

#workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
}

#workspaces button.focused {
    background-color: #64748b;
    border-bottom: 2px solid #33ccff;
}

#workspaces button.urgent {
    background-color: #f38ba8;
}

#mode {
    background-color: #64748b;
    border-bottom: 2px solid #cdd6f4;
}

#clock,
#battery,
#network,
#pulseaudio,
#idle_inhibitor,
#tray {
    padding: 0 10px;
    color: #cdd6f4;
}

#battery.charging, #battery.plugged {
    color: #a6e3a1;
}

@keyframes blink {
    to {
        background-color: #cdd6f4;
        color: #1e1e2e;
    }
}

#battery.critical:not(.charging) {
    background-color: #f38ba8;
    color: #cdd6f4;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

label:focus {
    background-color: #1e1e2e;
}

#network.disconnected {
    color: #f38ba8;
}
EOF

# =============================================================================
# HYPRPAPER CONFIGURATION
# =============================================================================

cat > /etc/skel/.config/hypr/hyprpaper.conf << 'EOF'
preload = /usr/share/backgrounds/default.jpg
wallpaper = , /usr/share/backgrounds/default.jpg
splash = false
EOF

# =============================================================================
# ROFI CONFIGURATION
# =============================================================================

mkdir -p /etc/skel/.config/rofi

cat > /etc/skel/.config/rofi/config.rasi << 'EOF'
configuration {
    modes: "drun,run,window";
    font: "Inter 12";
    show-icons: true;
    terminal: "kitty";
    drun-display-format: "{icon} {name}";
    location: 0;
    disable-history: false;
    hide-scrollbar: true;
    display-drun: "   Apps ";
    display-run: "   Run ";
    display-window: " 﩯  Window";
    display-Network: " 󰤨  Network";
    sidebar-mode: true;
}

@theme "~/.config/rofi/themes/catppuccin-mocha.rasi"
EOF

# Create rofi theme directory
mkdir -p /etc/skel/.config/rofi/themes

cat > /etc/skel/.config/rofi/themes/catppuccin-mocha.rasi << 'EOF'
* {
    bg-col:  #1e1e2e;
    bg-col-light: #1e1e2e;
    border-col: #33ccff;
    selected-col: #33ccff;
    blue: #33ccff;
    fg-col: #cdd6f4;
    fg-col2: #f38ba8;
    grey: #6c7086;

    width: 600;
    font: "Inter 14";
}

element-text, element-icon , mode-switcher {
    background-color: inherit;
    text-color:       inherit;
}

window {
    height: 360px;
    border: 2px;
    border-color: @border-col;
    background-color: @bg-col;
    border-radius: 8px;
}

mainbox {
    background-color: @bg-col;
}

inputbar {
    children: [prompt,entry];
    background-color: @bg-col;
    border-radius: 5px;
    padding: 2px;
}

prompt {
    background-color: @blue;
    padding: 6px;
    text-color: @bg-col;
    border-radius: 3px;
    margin: 20px 0px 0px 20px;
}

textbox-prompt-colon {
    expand: false;
    str: ":";
}

entry {
    padding: 6px;
    margin: 20px 0px 0px 10px;
    text-color: @fg-col;
    background-color: @bg-col;
}

listview {
    border: 0px 0px 0px;
    padding: 6px 0px 0px;
    margin: 10px 0px 0px 20px;
    columns: 2;
    lines: 5;
    background-color: @bg-col;
}

element {
    padding: 5px;
    background-color: @bg-col;
    text-color: @fg-col  ;
}

element-icon {
    size: 25px;
}

element selected {
    background-color:  @selected-col ;
    text-color: @fg-col2  ;
}

mode-switcher {
    spacing: 0;
  }

button {
    padding: 10px;
    background-color: @bg-col-light;
    text-color: @grey;
    vertical-align: 0.5; 
    horizontal-align: 0.5;
}

button selected {
  background-color: @bg-col;
  text-color: @blue;
}

message {
    background-color: @bg-col-light;
    margin: 2px;
    padding: 2px;
    border-radius: 5px;
}

textbox {
    padding: 6px;
    margin: 20px 0px 0px 20px;
    text-color: @blue;
    background-color: @bg-col-light;
}
EOF

# =============================================================================
# ENABLE SERVICES
# =============================================================================

# Enable GDM if not already enabled
systemctl enable gdm.service

echo "Hyprland post-installation setup completed successfully!"
echo "Users will need to log out and select Hyprland from the session menu."