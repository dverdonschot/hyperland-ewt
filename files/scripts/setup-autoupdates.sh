#!/usr/bin/env bash

set -oue pipefail

echo "Enabling automatic updates for system and applications..."

systemctl enable rpm-ostreed-automatic.timer
systemctl enable podman-auto-update.timer
systemctl --global enable podman-auto-update.timer
systemctl --global enable flatpak-user-update.timer
systemctl enable flatpak-system-update.timer

echo "Automatic updates enabled successfully!"
