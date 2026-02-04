#!/bin/bash

# Detect system architecture
ARCH=$(uname -m)
ARCH=${ARCH/aarch64/arm64}

bash ./install-common.sh
ansible-playbook -K --connection=local -i 127.0.0.1, geoscripting-gui.yml --extra-vars "system_arch=$ARCH"
