#!/bin/sh
# Script for installing necessary software on an Ubuntu 16.04 VDI

# WARNING: You should manually run an apt update && apt upgrade before this in an ssh session! Ideally also reboot between that and running this script.

# DM: VMWare Horizon settings: do not inherit keyboard layouts
sudo sed -i "s/#KeyboardLayoutSync=FALSE/KeyboardLayoutSync=FALSE/" /etc/vmware/viewagent-custom.conf
# DM: Set to use GNOME Flashback
sudo sed -i "s/#UseGnomeFlashback=TRUE/UseGnomeFlashback=TRUE/" /etc/vmware/viewagent-custom.conf
echo "SSODesktopType=UseGnomeFlashback" | sudo tee -a /etc/vmware/viewagent-custom.conf
# DM: Set sudo timeout to an hour
sudo sed -i "s/Defaults\tenv_reset/Defaults\tenv_reset,timestamp_timeout=60/" /etc/sudoers
# DM: Disable prompt to upgrade to 18.04, that would be disastrous for current VMWare version
sudo sed -i "s/Prompt=.*/Prompt=never/" /etc/update-manager/release-upgrades

# DM: GNOME Fallback options instead, based on dconf
sudo cp user /etc/dconf/profile/
sudo mkdir /etc/dconf/db/geoscripting.d
sudo cp 10-geoscripting /etc/dconf/db/geoscripting.d
sudo dconf update

sudo apt-mark hold samba

# DM: Proceed to the common install part
pushd ../xenial
sh install-common.sh
popd

echo "Installation complete, reboot and run ./free-space.sh to free up disk space on the VDI."
