#!/bin/bash
# DM: Remove unnecessary software from VDIs

# DM: Remove rsyslog, already have journald; snapd is for servers
sudo systemctl disable rsyslog snapd
sudo systemctl stop rsyslog syslog.socket snapd snapd.socket

# DM: Remove extra browsers, text editors, games, scanning, large docs
sudo apt purge --auto-remove rsyslog snapd chromium-browser thunderbird vim vim-common gnome-user-guide libreoffice-help-en-gb libreoffice-help-en-us aisleriot gnome-mahjongg gnome-mines gnome-sudoku shotwell cheese simple-scan gnome-screensaver 
# DM: If using Xfce, we do not use indicators, can remove
#sudo apt purge --auto-remove indicator-session indicator-applet indicator-applet-complete indicator-application indicator-bluetooth indicator-datetime indicator-keyboard indicator-messages indicator-power indicator-printers indicator-sound
# DM: If using Xfce, remove GNOME utilities that duplicate Xfce ones
#sudo apt purge --auto-remove unity gedit nautilus eog gnome-system-monitor gnome-terminal evolution-data-server network-manager-gnome network-manager-pptp-gnome light-locker xscreensaver blueman

# Clean all old kernels
sudo apt install byobu
sudo purge-old-kernels --keep 1
sudo apt purge --auto-remove byobu

# Remove unneeded packages and clean cache
sudo apt autoremove
sudo apt-get clean
