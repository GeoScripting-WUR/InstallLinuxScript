#!/bin/bash

# Detect system architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        SYSTEM_ARCH="amd64"
        echo "✓ Detected system architecture: AMD64 (x86_64)"
        ;;
    aarch64)
        SYSTEM_ARCH="arm64"
        echo "✓ Detected system architecture: ARM64 (aarch64)"
        ;;
    *)
        echo "⚠ Warning: Unsupported architecture detected: $ARCH"
        echo "This installation script supports AMD64 and ARM64 architectures only."
        exit 1
        ;;
esac

# Detect Ubuntu version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "ubuntu" ]; then
        echo "✓ Detected Ubuntu version: $VERSION ($VERSION_CODENAME)"
        UBUNTU_VERSION=$VERSION_ID
        UBUNTU_CODENAME=$VERSION_CODENAME
    else
        echo "⚠ Warning: This script is designed for Ubuntu systems."
        echo "Detected OS: $PRETTY_NAME"
        echo "Proceeding anyway, but some packages may not be available..."
    fi
else
    echo "⚠ Warning: Could not detect OS version. /etc/os-release not found."
    echo "Assuming Ubuntu and proceeding..."
fi

echo ""
echo "Starting installation with the following configuration:"
echo "- Architecture: $SYSTEM_ARCH"
echo "- Ubuntu Version: ${VERSION:-Unknown}"
echo "- Ubuntu Codename: ${VERSION_CODENAME:-Unknown}"
echo ""

# Check if install-common.sh exists before trying to run it
if [ -f "./install-common.sh" ]; then
    bash ./install-common.sh
else
    echo "Note: install-common.sh not found, skipping..."
fi

# Run ansible playbook with architecture variable
ansible-playbook -K --connection=local -i 127.0.0.1, geoscripting-gui.yml --extra-vars "system_arch=$SYSTEM_ARCH ubuntu_codename=${UBUNTU_CODENAME:-jammy}"
