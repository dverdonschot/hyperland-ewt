#!/usr/bin/env bash

set -oue pipefail

echo "Setting up just command runner integration..."

# Create the justfile directory if it doesn't exist
mkdir -p /usr/share/ublue-os/just

# Add brew integration import to system justfile
if [[ -f /usr/share/ublue-os/justfile ]]; then
    echo 'import "/usr/share/ublue-os/just/50-brew.just"' >> /usr/share/ublue-os/justfile
else
    # Create the justfile if it doesn't exist
    cat > /usr/share/ublue-os/justfile << 'EOF'
# System-wide justfile for Hyperland-EWT
import "/usr/share/ublue-os/just/50-brew.just"
EOF
fi

echo "Just command runner setup completed!"
