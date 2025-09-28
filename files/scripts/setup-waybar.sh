#!/usr/bin/env bash

# Waybar Configuration Setup
# Creates waybar configuration and styling

set -oue pipefail

echo "Setting up Waybar configuration..."

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

echo "Waybar configuration setup completed!"