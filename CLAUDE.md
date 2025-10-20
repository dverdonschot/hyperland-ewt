# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Hyprland-based custom Fedora Atomic OS image** built with BlueBuild. It transforms Universal Blue Silverblue into a modern, keyboard-driven workspace featuring the Hyprland tiling window manager with comprehensive configuration management.

## Core Architecture

- **Base Image**: Built on `ghcr.io/ublue-os/silverblue-main` (Fedora 42)
- **Window Manager**: Hyprland (Wayland-native dynamic tiling compositor)
- **Build System**: BlueBuild framework using GitHub Actions
- **Configuration**: YAML-based recipe system with modular Hyprland configs
- **Signing**: Uses cosign for container image signing with automatic key management

## Key Features

- **Hyprland Desktop Environment**: Complete Wayland-based tiling setup
- **Modular Configuration**: Separate files for keybinds, startup, window rules, themes
- **Configuration Management**: System-wide defaults with user customization support
- **ALT as Primary Modifier**: Efficient keyboard-driven workflow
- **Update-Safe Customization**: Preserves user modifications during system updates

## Key Files and Structure

### Build Configuration
- `recipes/recipe.yml` - Main build configuration with Hyprland packages and COPR repos
- `.github/workflows/build.yml` - Automated build pipeline (daily + on changes)
- `files/scripts/hypr-post-install.sh` - Post-installation Hyprland setup script

### Hyprland Configuration System
- `files/system/etc/hypr/` - System-wide Hyprland configuration templates
  - `hyprland.conf` - Main configuration file
  - `keybinds.conf` - Keybinding definitions (ALT as $mainMod)
  - `startup.conf` - Autostart applications
  - `window-rules.conf` - Window management rules and workspace assignments
  - `monitors.conf` - Monitor configuration and positioning
  - `themes/default.conf` - Visual theme and animation settings

### User Management Scripts
- `files/system/usr/bin/hypr-setup` - Initial user configuration setup
- `files/system/usr/bin/hypr-update-config` - Configuration update tool
- `files/system/usr/bin/hypr-keybind-help` - Interactive keybinding reference

### Setup Scripts
- `files/scripts/setup-virtualization.sh` - Configures libvirt, podman, and k3s services

### Documentation
- `README.md` - User-facing documentation and installation guide
- `HYPRLAND_SPEC.md` - Detailed technical specification

## Package Management

### Added Packages (via solopasha/hyprland COPR)
- **Core Hyprland**: `hyprland`, `xdg-desktop-portal-hyprland`, `hyprland-contrib`
- **Wayland Ecosystem**: `waybar`, `rofi-wayland`, `kitty`, `dunst`, `thunar`
- **Utilities**: `hyprpaper`, `hyprpicker`, `grim`, `slurp`, `wl-clipboard`, `swaylock`
- **System Tools**: `brightnessctl`, `fastfetch`, `jq`, `qt5-qtwayland`, `qt6-qtwayland`
- **Containers**: `podman`, `podman-compose`
- **Virtualization**: `libvirt`, `libvirt-daemon-kvm`, `qemu-kvm`, `virt-manager`, `virt-install`, `virt-viewer`
- **Kubernetes**: `k3s`, `kubernetes-client` (kubectl), `helm`
- **Hardware Tools**: `qmk`, `arduino`, `usbutils`, `pciutils`, `hwinfo`, `lshw`
- **Network Tools**: `bind-utils` (nslookup, dig), `nmap`, `nmap-ncat` (nc), `iputils` (ping), `tcpdump`, `wireshark`, `mtr`
- **System Monitoring**: `htop`, `btop`, `iotop`, `iftop`, `nethogs`, `sysstat`, `lsof`, `strace`
- **File Browsing**: `tree`, `ranger`, `mc`, `fzf`, `ripgrep`, `fd-find`, `bat`, `eza`
- **TUI Apps**: `lazygit`, `lazydocker`, `dive`, `ctop`, `podman-tui`, `ncdu`
- **Flatpak Apps**: Zed editor, Zen browser, k9s (Kubernetes TUI)

### Removed Packages
- GNOME Shell extensions that conflict with Hyprland
- Default Firefox package (replaced with Flatpak)

## Build Commands

### Automatic Builds
- **Schedule**: Daily builds at 06:00 UTC
- **Triggers**: Push to main branch (excluding .md files)
- **Manual**: GitHub Actions "workflow_dispatch" event

### Local Development
- No local build commands (container-based system)
- Test configuration changes by modifying files in `files/system/etc/hypr/`
- Scripts in `files/scripts/` are executed during build

## Module System (BlueBuild)

Build sequence:
1. **files** - Copies `files/system/` to root filesystem
2. **dnf** - Installs Hyprland packages from COPR, removes conflicts
3. **default-flatpaks** - Installs Firefox, GNOME Loupe, Flatseal, Zed, Zen browser, k9s
4. **script** - Runs `hypr-post-install.sh` for system setup (includes virtualization setup)
5. **signing** - Container signing infrastructure

## Hyprland Configuration Management

### System Configuration Flow
1. **Build Time**: System configs installed to `/etc/hypr/`
2. **First Login**: `hypr-setup` copies configs to `~/.config/hypr/`
3. **Updates**: `hypr-update-config` merges system updates with user customizations
4. **Customization**: Users modify files in `~/.config/hypr/`

### Key Configuration Features
- **Configurable Modifier Key**: Change `$mainMod` in `keybinds.conf` (ALT/SUPER/CTRL)
- **Modular Design**: Separate concerns (keybinds, startup, rules, themes)
- **Update Safety**: Preserves user modifications during system updates
- **Help System**: `hypr-keybind-help` provides interactive reference

## Default Keybindings (ALT Modifier)

### Essential Shortcuts
- `ALT + Q`: Terminal
- `ALT + R`: Application launcher
- `ALT + E`: File manager
- `ALT + Shift + Q`: Close window
- `ALT + F1`: Keybinding help

### Window Management
- `ALT + H/J/K/L`: Focus windows (Vim-style)
- `ALT + Shift + H/J/K/L`: Move windows
- `ALT + F`: Toggle floating
- `ALT + Shift + F`: Toggle fullscreen

### Workspaces
- `ALT + 1-9,0`: Switch workspaces
- `ALT + Shift + 1-9,0`: Move window to workspace
- `ALT + Tab`: Next workspace

## Development Workflow

### Configuration Changes
1. Modify files in `files/system/etc/hypr/`
2. Test with build or update existing installation
3. Scripts should include `set -oue pipefail`
4. All scripts in `/usr/bin/hypr-*` must be executable

### User Experience Testing
1. Test `hypr-setup` for new user initialization
2. Verify `hypr-update-config` preserves customizations
3. Ensure `hypr-keybind-help` displays current bindings
4. Check modular config file loading

### Build Testing
- Builds trigger on push (excluding .md files)
- Monitor GitHub Actions for build success
- Test installation on clean Fedora Atomic system

## Image Installation

Users install via rpm-ostree rebase:
```bash
# Initial (unsigned):
rpm-ostree rebase ostree-unverified-registry:ghcr.io/dverdonschot/hyperland-ewt:latest
systemctl reboot

# Signed (after reboot):
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/dverdonschot/hyperland-ewt:latest
systemctl reboot

# Initialize Hyprland:
hypr-setup
```

## Container and Virtualization

### Podman Setup
- **Service**: Enabled via `podman.socket` for docker-compose compatibility
- **Docker alias**: Podman can be aliased as `docker` for compatibility
- **Registries**: docker.io, quay.io, ghcr.io configured by default
- **Usage**: `podman run`, `podman-compose up`

### Libvirt/KVM Setup
- **Services**: `libvirtd`, `virtnetworkd`, `virtqemud` enabled at build
- **User Access**: Users must be added to `libvirt` group: `sudo usermod -aG libvirt $USER`
- **Default Network**: Configured automatically via `libvirt-daemon-config-network`
- **GUI**: `virt-manager` for graphical VM management
- **CLI**: `virsh` for command-line VM control

### Kubernetes Tools
- **k3s**: Disabled by default (enable via `sudo systemctl enable --now k3s`)
- **kubectl**: Available as `kubectl` command
- **helm**: Package manager for Kubernetes
- **k9s**: Terminal UI for Kubernetes (Flatpak)

### Hardware Tools
- **QMK**: For custom keyboard firmware (command: `qmk`)
- **Arduino**: IDE for Arduino development (Flatpak or RPM)
- **USB Info**: `lsusb`, `usb-devices` for USB device inspection
- **Hardware Info**: `lspci`, `hwinfo`, `lshw` for system hardware details

## Network and System Tools

### Network Diagnostics
- **DNS**: `nslookup`, `dig`, `host` (from bind-utils)
- **Port Scanning**: `nmap` for network discovery
- **Network Testing**: `ping`, `mtr` (combines ping + traceroute)
- **Netcat**: `nc` (ncat from nmap-ncat package)
- **Packet Analysis**: `tcpdump`, `wireshark`
- **Bandwidth**: `iftop`, `nethogs` (per-process network usage)

### System Monitoring TUIs
- **Process Monitoring**: `htop` (classic), `btop` (modern with graphs)
- **I/O Monitoring**: `iotop` (disk I/O by process)
- **Network**: `iftop` (bandwidth), `nethogs` (per-process)
- **Disk Usage**: `ncdu` (interactive disk usage analyzer)
- **Performance**: `sysstat` tools (`sar`, `iostat`, `mpstat`)

### File and Directory Tools
- **File Managers**: `ranger` (vim-style TUI), `mc` (Midnight Commander)
- **Directory Tree**: `tree` (visual directory structure)
- **Fuzzy Finding**: `fzf` (interactive fuzzy finder)
- **Fast Search**: `ripgrep` (rg), `fd-find` (fd) - modern grep/find
- **Enhanced Viewing**: `bat` (cat with syntax highlighting), `eza` (modern ls)

### Development TUIs
- **Git**: `lazygit` (interactive Git interface)
- **Containers**: `lazydocker` (Docker/Podman TUI), `ctop` (container metrics), `podman-tui`
- **Images**: `dive` (explore Docker/Podman image layers)
- **Kubernetes**: `k9s` (Kubernetes cluster management)

## Troubleshooting Commands

- **Configuration Reset**: `hypr-update-config --force`
- **View Logs**: `journalctl --user -u hyprland`
- **Backup Configs**: `hypr-update-config --backup`
- **Preview Updates**: `hypr-update-config --dry-run`
- **Libvirt Network**: `sudo virsh net-start default` (if network doesn't auto-start)
- **Podman Socket**: `systemctl --user enable --now podman.socket`

## Verification

Images are signed with cosign:
```bash
cosign verify --key cosign.pub ghcr.io/dverdonschot/hyperland-ewt
```