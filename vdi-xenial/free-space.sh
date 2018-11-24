#!/bin/bash
# DM: Remove unnecessary software from VDIs

# DM: Remove rsyslog, already have journald; snapd is for servers
sudo systemctl disable rsyslog snapd
sudo systemctl stop rsyslog syslog.socket snapd snapd.socket

# DM: Remove extra browsers, text editors, terminals, games, scanning, large docs
sudo apt purge --auto-remove rsyslog snapd chromium-browser thunderbird vim vim-common xterm gnome-user-guide libreoffice-help-en-gb libreoffice-help-en-us aisleriot gnome-mahjongg gnome-mines gnome-sudoku shotwell cheese simple-scan gnome-screensaver totem rhythmbox

# Clean all old kernels
sudo apt install byobu
sudo purge-old-kernels --keep 1
sudo apt purge --auto-remove byobu

# Remove unneeded packages and clean cache
sudo apt autoremove
sudo apt clean
