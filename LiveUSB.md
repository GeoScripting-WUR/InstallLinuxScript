# Getting a persistent LiveUSB

The general outline is given in [http://geoscripting-wur.github.io/system_setup/index.html#Persistent_Live_USB](http://geoscripting-wur.github.io/system_setup/index.html#Persistent_Live_USB). Some extra notes for bulk LiveUSB creation that does not require a USB-stck-making-USB-stick:

1. Download the ISO file
1. Format the USB stick so that it has one 550 MB FAT32 "ESP" + 5 GiB EXT4 "Ubuntu" + rest of USB EXT4 "casper-rw"
1. Use unetbootin to install it onto the Ubuntu partition
1. Remove casper-rw file from Ubuntu partition
1. Change ESP/boot/grub/grub.cfg to have the string "persistent"
1. Run on a computer to run the bionic script in this repo

Exercise: can we write a bash script for automating this?
