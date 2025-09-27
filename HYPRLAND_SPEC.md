# Hyprland Custom Image Specification

## Project Overview
Transform the current Universal Blue Silverblue-based image into a custom Hyprland-powered workspace with centralized configuration management for optimal efficiency and customizable keybindings.

## Base Image Change
**Current**: `ghcr.io/ublue-os/silverblue-main:42`  
**Target**: `ghcr.io/ublue-os/silverblue-main:42` (keeping base, adding Hyprland on top)

**Rationale**: Since Universal Blue no longer maintains official Hyprland images, we'll build Hyprland on top of the stable Silverblue base using the well-maintained `solopasha/hyprland` COPR repository.

## Architecture Design

### 1. Package Management Strategy
```yaml
# Add to recipe.yml
dnf:
  repos:
    copr:
      - solopasha/hyprland  # Primary Hyprland packages
      - atim/starship       # Keep existing
  install:
    packages:
      # Core Hyprland
      - hyprland
      - xdg-desktop-portal-hyprland
      - hyprland-contrib
      - hyprpaper
      - hyprpicker
      
      # Essential Wayland ecosystem
      - waybar              # Status bar
      - rofi-wayland        # Application launcher
      - kitty               # Terminal emulator
      - dunst               # Notifications
      - thunar              # File manager
      - qt5-qtwayland       # Qt5 Wayland support
      - qt6-qtwayland       # Qt6 Wayland support
      
      # System utilities
      - brightnessctl       # Brightness control
      - fastfetch           # System info
      - jq                  # JSON processor
      - grim                # Screenshot utility
      - slurp               # Screen area selection
      - wl-clipboard        # Wayland clipboard
      
      # Keep existing
      - micro
      - starship
```

### 2. Configuration Management Approach

#### **Option A: System-wide Configuration (Recommended)**
- **Location**: `/etc/hypr/` → copies to user's `~/.config/hypr/`
- **Benefits**: Consistent defaults, easy updates, user can override
- **Implementation**: Use BlueBuild `files` module

#### **Option B: User Profile Templates**
- **Location**: `/etc/skel/.config/hypr/`
- **Benefits**: Automatic for new users
- **Limitation**: Doesn't affect existing users

#### **Selected Approach: Hybrid System**
1. **System defaults**: `/etc/hypr/` with base configuration
2. **User initialization script**: Copies system config to user directory on first login
3. **Update mechanism**: Script to sync system changes to user configs

### 3. Configuration File Structure
```
files/system/etc/hypr/
├── hyprland.conf           # Main configuration
├── keybinds.conf          # Keybinding definitions
├── startup.conf           # Autostart applications
├── window-rules.conf      # Window management rules
├── monitors.conf          # Monitor configuration
└── themes/
    ├── default.conf       # Default theme
    └── dark.conf          # Dark theme variant
```

### 4. Keybinding System Design

#### **Configurable Modifier Key**
```conf
# In keybinds.conf
$mainMod = SUPER              # Default: Windows/Super key
# Alternative options: ALT, CTRL, SUPER_SHIFT

# Easy switching
$mainMod = ALT                # Uncomment for Alt-based workflow
# $mainMod = SUPER            # Uncomment for Super-based workflow
```

#### **Core Keybinding Categories**

**System Control**
```conf
bind = $mainMod, Q, exec, $terminal
bind = $mainMod SHIFT, Q, killactive
bind = $mainMod SHIFT, E, exit
bind = $mainMod, L, exec, hyprlock
```

**Application Launchers**
```conf
bind = $mainMod, R, exec, rofi -show drun
bind = $mainMod, E, exec, thunar
bind = $mainMod, B, exec, firefox
bind = $mainMod, C, exec, code
```

**Window Management**
```conf
bind = $mainMod, F, togglefloating
bind = $mainMod, P, pseudo
bind = $mainMod, J, togglesplit
bind = $mainMod SHIFT, F, fullscreen
```

**Workspace Navigation**
```conf
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
# ... (1-10)
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
```

**Productivity Shortcuts**
```conf
bind = $mainMod, Tab, cyclenext
bind = $mainMod SHIFT, Tab, cyclenext, prev
bind = $mainMod, G, togglegroup
bind = $mainMod, S, exec, grim -g "$(slurp)" - | wl-copy
```

## Implementation Plan

### Phase 1: Base Setup
1. **Update recipe.yml**
   - Change package installations
   - Add Hyprland COPR repository
   - Remove GNOME-specific packages

2. **Create configuration structure**
   - Set up `/etc/hypr/` directory structure
   - Create modular configuration files
   - Implement theme system

### Phase 2: Configuration Management
1. **Create initialization script**
   - Copy system configs to user directory
   - Set proper permissions
   - Handle existing user configs

2. **Implement update mechanism**
   - Script to merge system updates with user customizations
   - Backup system for user modifications

### Phase 3: Optimization & Polish
1. **Performance tuning**
   - Optimize Hyprland settings for efficiency
   - Configure proper rendering backend
   - Set up appropriate animations

2. **User experience**
   - Create configuration documentation
   - Add helpful scripts and utilities
   - Implement status bar configuration

## File Structure Changes

### New Directory Layout
```
files/system/
├── etc/
│   ├── hypr/                    # Hyprland system configs
│   ├── skel/.config/hypr/       # User template configs
│   └── profile.d/hyprland.sh    # Environment setup
├── usr/
│   ├── bin/
│   │   ├── hypr-setup          # Initial configuration script
│   │   ├── hypr-update-config  # Configuration update script
│   │   └── hypr-keybind-help   # Keybinding reference
│   └── share/
│       ├── hyprland/           # Additional resources
│       └── applications/       # Desktop entries
```

### Updated Recipe Structure
```yaml
modules:
  - type: files
    files:
      - source: system
        destination: /

  - type: dnf
    repos:
      copr:
        - solopasha/hyprland
        - atim/starship
    install:
      packages: [hyprland packages...]
    remove:
      packages:
        - gnome-shell
        - gdm  # Consider keeping for compatibility
        - firefox
        - firefox-langpacks

  - type: default-flatpaks
    # Keep existing flatpak configuration

  - type: script
    scripts:
      - hypr-post-install.sh  # Post-installation setup

  - type: signing
```

## Expected Benefits

1. **Efficiency**: Tiling window manager optimized for keyboard-driven workflow
2. **Customization**: Easy modification of keybindings and behavior
3. **Performance**: Lightweight compared to full desktop environments
4. **Modernization**: Wayland-native with proper display protocol support
5. **Maintainability**: Centralized configuration management
6. **Flexibility**: Users can override system defaults while maintaining update path

## Migration Considerations

1. **Display Manager**: Evaluate keeping GDM vs switching to SDDM
2. **Application Compatibility**: Test critical applications on Wayland
3. **NVIDIA Support**: Ensure proper configuration for NVIDIA users
4. **User Training**: Provide documentation for Hyprland workflow
5. **Backup Strategy**: Implement user configuration backup before updates

## Success Metrics

1. **Functional**: Hyprland starts and operates correctly
2. **Configurable**: Users can easily modify mod key and keybindings
3. **Maintainable**: System updates don't break user customizations
4. **Documented**: Clear instructions for customization and troubleshooting
5. **Performant**: Responsive window management and smooth animations

This specification provides a comprehensive roadmap for transforming your Universal Blue image into an efficient, customizable Hyprland-based workspace while maintaining the benefits of atomic updates and centralized configuration management.