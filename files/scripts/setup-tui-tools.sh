#!/usr/bin/env bash

set -oue pipefail

echo "Installing TUI tools from alternative sources..."

INSTALL_DIR="/usr/local/bin"

install_from_github() {
    local repo=$1
    local binary_name=$2
    local asset_pattern=$3
    
    echo "Installing ${binary_name}..."
    
    latest_url=$(curl -s "https://api.github.com/repos/${repo}/releases/latest" | \
        jq -r ".assets[] | select(.name | test(\"${asset_pattern}\")) | .browser_download_url")
    
    if [ -z "$latest_url" ]; then
        echo "Warning: Could not find release for ${binary_name}"
        return 1
    fi
    
    tmpfile=$(mktemp)
    curl -sL "$latest_url" -o "$tmpfile"
    
    if [[ "$latest_url" == *.tar.gz ]]; then
        tar xzf "$tmpfile" -C /tmp
        if [ -f "/tmp/${binary_name}" ]; then
            install -m 755 "/tmp/${binary_name}" "${INSTALL_DIR}/${binary_name}"
        else
            find /tmp -name "${binary_name}" -type f -exec install -m 755 {} "${INSTALL_DIR}/${binary_name}" \;
        fi
    elif [[ "$latest_url" == *.zip ]]; then
        unzip -q "$tmpfile" -d /tmp
        find /tmp -name "${binary_name}" -type f -exec install -m 755 {} "${INSTALL_DIR}/${binary_name}" \;
    else
        install -m 755 "$tmpfile" "${INSTALL_DIR}/${binary_name}"
    fi
    
    rm -f "$tmpfile"
    echo "${binary_name} installed successfully"
}

install_lazygit() {
    install_from_github "jesseduffield/lazygit" "lazygit" "Linux_x86_64.tar.gz"
}

install_lazydocker() {
    install_from_github "jesseduffield/lazydocker" "lazydocker" "Linux_x86_64.tar.gz"
}

install_dive() {
    install_from_github "wagoodman/dive" "dive" "linux_amd64.tar.gz"
}

install_ctop() {
    echo "Installing ctop..."
    curl -sL https://github.com/bcicen/ctop/releases/latest/download/ctop-0.7.7-linux-amd64 -o "${INSTALL_DIR}/ctop"
    chmod 755 "${INSTALL_DIR}/ctop"
}

install_systemctl_tui() {
    echo "Installing systemctl-tui..."
    local tmpfile=$(mktemp)
    curl -sL "https://github.com/rgwood/systemctl-tui/releases/latest/download/systemctl-tui-x86_64-unknown-linux-musl" -o "$tmpfile"
    install -m 755 "$tmpfile" "${INSTALL_DIR}/systemctl-tui"
    rm -f "$tmpfile"
}

install_eza
install_lazygit
install_lazydocker
install_dive
install_ctop
install_systemctl_tui

echo "All TUI tools installed successfully!"
