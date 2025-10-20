#!/usr/bin/env bash

# Virtualization and Container Setup Script
# Configures libvirt, podman, and k3s services

set -oue pipefail

echo "Setting up virtualization and container services..."

# =============================================================================
# LIBVIRT CONFIGURATION
# =============================================================================

echo "Configuring libvirt services..."

# Enable and start libvirtd
systemctl enable libvirtd.service

# Enable default network for libvirt
systemctl enable virtnetworkd.service
systemctl enable virtqemud.service

# Configure libvirt default network to start automatically
mkdir -p /etc/libvirt
cat > /etc/libvirt/libvirtd.conf <<'EOF'
# Listen for TCP/IP connections
# unix_sock_group = "libvirt"
# unix_sock_rw_perms = "0770"
EOF

# =============================================================================
# PODMAN CONFIGURATION
# =============================================================================

echo "Configuring podman..."

# Enable podman socket for docker-compose compatibility
systemctl enable podman.socket

# Create default containers storage configuration
mkdir -p /etc/containers
cat > /etc/containers/registries.conf <<'EOF'
unqualified-search-registries = ["docker.io", "quay.io", "ghcr.io"]

[[registry]]
prefix = "docker.io"
location = "docker.io"
EOF

# Configure storage for better performance
cat > /etc/containers/storage.conf <<'EOF'
[storage]
driver = "overlay"
runroot = "/run/containers/storage"
graphroot = "/var/lib/containers/storage"

[storage.options]
additionalimagestores = [
  "/usr/lib/containers/storage"
]
EOF

# =============================================================================
# K3S CONFIGURATION
# =============================================================================

echo "Configuring k3s..."

# Create k3s config directory
mkdir -p /etc/rancher/k3s

# K3s will be configured at runtime by users via:
# systemctl enable --now k3s
# Note: k3s is disabled by default to avoid resource usage

echo "Virtualization and container setup completed!"
echo ""
echo "Post-install user actions required:"
echo "1. Add user to libvirt group: sudo usermod -aG libvirt \$USER"
echo "2. Start libvirt: sudo systemctl start libvirtd"
echo "3. Enable k3s (optional): sudo systemctl enable --now k3s"
