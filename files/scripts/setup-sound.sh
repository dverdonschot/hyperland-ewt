#!/usr/bin/env bash

# Audio System Setup Script
# Configures PipeWire, WirePlumber, and Bluetooth audio

set -oue pipefail

echo "Configuring audio system (PipeWire/WirePlumber)..."

# Enable Bluetooth service at system level
systemctl enable bluetooth.service

# Create user systemd service directory if it doesn't exist
mkdir -p /etc/skel/.config/systemd/user/default.target.wants

# PipeWire and WirePlumber will auto-start via user session
# No need to manually enable - they use socket activation

echo "Audio system configuration completed!"
echo "PipeWire, WirePlumber, and Bluetooth are ready to use."
