# Hyperland-EWT: Personal Hyprland Workspace &nbsp; [![bluebuild build badge](https://github.com/dverdonschot/hyperland-ewt/actions/workflows/build.yml/badge.svg)](https://github.com/dverdonschot/hyperland-ewt/actions/workflows/build.yml)

A highly customized Fedora Atomic desktop image featuring **Hyprland** - a modern, efficient tiling window manager built for productivity. This image transforms the Universal Blue Silverblue base into a keyboard-driven workspace optimized for developers and power users.

## ✨ Key Features

### 🖥️ **Modern Tiling Window Manager**
- **Hyprland**: Wayland-native dynamic tiling compositor
- **Efficient Workflow**: Keyboard-driven interface with ALT as primary modifier
- **Beautiful Animations**: Smooth, configurable animations and effects
- **Multi-Monitor Support**: Flexible monitor configuration and workspace management

### 🎛️ **Comprehensive Desktop Environment**
- **Waybar**: Modern status bar with system information
- **Rofi**: Elegant application launcher and window switcher  
- **Kitty**: GPU-accelerated terminal emulator
- **Thunar**: Lightweight file manager
- **Dunst**: Customizable notification system

### ⚙️ **Configuration Management System**
- **Modular Configs**: Separate files for keybinds, startup, window rules, and themes
- **Easy Customization**: Simple modifier key switching (ALT/SUPER/CTRL)
- **Update-Safe**: Preserves user customizations during system updates
- **Centralized Management**: System-wide defaults with user override capability

### 🔧 **Developer Tools Included**
- **Micro**: Modern terminal text editor
- **Starship**: Cross-shell prompt with Git integration
- **Development Utilities**: Screenshot tools, clipboard management, brightness control
- **Wayland Ecosystem**: Full Qt5/Qt6 and GTK Wayland support

## 🚀 Installation

> [!WARNING]  
> This is an experimental Fedora Atomic feature. Use at your own discretion.

### Rebase from Existing Fedora Atomic Installation

1. **Rebase to unsigned image** (to install signing keys):
   ```bash
   rpm-ostree rebase ostree-unverified-registry:ghcr.io/dverdonschot/hyperland-ewt:latest
   ```

2. **Reboot** to complete the rebase:
   ```bash
   systemctl reboot
   ```

3. **Rebase to signed image**:
   ```bash
   rpm-ostree rebase ostree-image-signed:docker://ghcr.io/dverdonschot/hyperland-ewt:latest
   ```

4. **Final reboot**:
   ```bash
   systemctl reboot
   ```

5. **Initialize Hyprland configuration**:
   ```bash
   hypr-setup
   ```

### First Login
- Log out and select "Hyprland" from the GDM session menu
- Your personalized Hyprland environment will start automatically

## 🎯 What's Different from Base Image

### **Removed Components**
- GNOME Shell and extensions (replaced with Hyprland)
- Default Firefox package (replaced with Flatpak version)
- GNOME-specific utilities that conflict with Hyprland

### **Added Packages**
- **Core Hyprland**: `hyprland`, `xdg-desktop-portal-hyprland`, `hyprland-contrib`
- **Wayland Ecosystem**: `waybar`, `rofi-wayland`, `dunst`, `hyprpaper`, `hyprpicker`
- **System Utilities**: `grim`, `slurp`, `wl-clipboard`, `swaylock`, `brightnessctl`
- **Development Tools**: `kitty`, `thunar`, `fastfetch`, `jq`
- **Qt/GTK Support**: `qt5-qtwayland`, `qt6-qtwayland`

### **Configuration Management**
- **System Templates**: Pre-configured Hyprland, Waybar, and Rofi setups
- **User Scripts**: `hypr-setup`, `hypr-update-config`, `hypr-keybind-help`
- **Modular Design**: Separate configuration files for different aspects
- **Theme System**: Customizable appearance with default modern theme

### **Enhanced Flatpaks**
- **Firefox**: Latest browser with Wayland support
- **GNOME Loupe**: Modern image viewer
- **Flatseal**: Flatpak permissions manager

## ⌨️ Default Keybindings (ALT as Modifier)

### **System Control**
- `ALT + Q`: Open terminal
- `ALT + Shift + Q`: Close window
- `ALT + Shift + E`: Exit Hyprland
- `ALT + L`: Lock screen
- `ALT + Shift + R`: Reload configuration

### **Applications**
- `ALT + R`: Application launcher (Rofi)
- `ALT + E`: File manager
- `ALT + B`: Web browser
- `ALT + C`: Code editor

### **Window Management**
- `ALT + F`: Toggle floating
- `ALT + Shift + F`: Toggle fullscreen
- `ALT + H/J/K/L`: Focus windows (Vim-style)
- `ALT + Shift + H/J/K/L`: Move windows

### **Workspaces**
- `ALT + 1-9,0`: Switch to workspace
- `ALT + Shift + 1-9,0`: Move window to workspace
- `ALT + Tab`: Next workspace
- `ALT + S`: Toggle scratchpad

### **Utilities**
- `ALT + Print`: Full screenshot
- `ALT + Shift + Print`: Area screenshot
- `ALT + F1`: Show keybinding help

## 🛠️ Customization

### **Change Modifier Key**
Edit `~/.config/hypr/keybinds.conf`:
```bash
# Change from ALT to Super (Windows key)
$mainMod = SUPER

# Or use Alt+Shift combination
$mainMod = ALT_SHIFT
```

### **Update Configuration**
```bash
# Interactive update (preserves customizations)
hypr-update-config

# Force update all files
hypr-update-config --force

# Preview changes without applying
hypr-update-config --dry-run
```

### **View Current Keybindings**
```bash
# Show all keybindings
hypr-keybind-help

# Show in interactive rofi menu
hypr-keybind-help --rofi

# Search for specific bindings
hypr-keybind-help --search terminal
```

## 📁 Configuration Structure

```
~/.config/hypr/
├── hyprland.conf          # Main configuration
├── keybinds.conf          # Keybinding definitions
├── startup.conf           # Autostart applications
├── window-rules.conf      # Window management rules
├── monitors.conf          # Monitor configuration
├── hyprpaper.conf         # Wallpaper settings
└── themes/
    └── default.conf       # Visual theme settings
```

## 🔄 Updating

The image automatically builds daily and on changes. To update:

```bash
# Update the system
rpm-ostree upgrade

# Reboot to apply updates
systemctl reboot

# Update Hyprland configurations
hypr-update-config
```

## 🆘 Troubleshooting

### **Configuration Issues**
- Reset to defaults: `hypr-update-config --force`
- Backup configs: `hypr-update-config --backup`
- Check logs: `journalctl --user -u hyprland`

### **Display Problems**
- Edit monitor config: `~/.config/hypr/monitors.conf`
- Reset to auto-detection: Set `monitor = , preferred, auto, 1`

### **Application Issues**
- Ensure Wayland support: Check environment variables in `/etc/profile.d/hyprland.sh`
- Force X11 apps: `GDK_BACKEND=x11 application-name`

## 🔐 Verification

Images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign):

```bash
cosign verify --key cosign.pub ghcr.io/dverdonschot/hyperland-ewt
```

## 📚 Learn More

- [Hyprland Wiki](https://wiki.hypr.land/) - Comprehensive Hyprland documentation
- [BlueBuild Docs](https://blue-build.org/) - Learn about building custom images
- [Universal Blue](https://universal-blue.org/) - Base image project
- [HYPRLAND_SPEC.md](./HYPRLAND_SPEC.md) - Detailed implementation specification

---

**Built with 💙 using [BlueBuild](https://blue-build.org/) and [Universal Blue](https://universal-blue.org/)**
