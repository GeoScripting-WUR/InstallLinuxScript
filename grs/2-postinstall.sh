#!/bin/bash

# Set up ssh access
sudo apt install ssh
# Make sure to do ssh-copy-id -i ...

# Edit /etc/fstab to have LABEL=Ubuntu and LABEL=Home, not UUIDs
sudo nano /etc/fstab

# If needed, readd devices and reset raid1 profiles

# Mount /tmp as tmpfs
echo "tmpfs /tmp tmpfs rw,nosuid,nodev" | sudo tee -a /etc/fstab
