#!/bin/bash
# DM: Remove unnecessary software from VDIs

# Remove rsyslog, already have journald; snapd is for servers; don't need two browsers
# Vim is confusing and there is nano already, unity and gnome-flashback no longer needed
# Also remove gnome utilities with Xfce equivalents and games
sudo systemctl disable rsyslog snapd
sudo systemctl stop rsyslog syslog.socket snapd snapd.service
sudo apt purge --auto-remove indicator-session indicator-applet indicator-applet-complete indicator-application indicator-bluetooth indicator-datetime indicator-keyboard indicator-messages indicator-power indicator-printers indicator-sound \
  rsyslog snapd chromium-browser vim vim-common gnome-user-guide unity gedit nautilus aisleriot gnome-mahjongg gnome-mines gnome-sudoku shotwell simple-scan eog usb-creator-common gnome-system-monitor gnome-terminal \
  blueman evolution-data-server network-manager-gnome network-manager-pptp-gnome xscreensaver gnome-screensaver light-locker

# Clean all old kernels
sudo apt install byobu
sudo purge-old-kernels --keep 1
sudo apt purge --auto-remove byobu

# Remove unneeded packages and clean cache
sudo apt autoremove
sudo apt-get clean
