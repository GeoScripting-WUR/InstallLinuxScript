# Getting a persistent LiveUSB

The general outline is given in [http://geoscripting-wur.github.io/system_setup/index.html#Persistent_Live_USB](http://geoscripting-wur.github.io/system_setup/index.html#Persistent_Live_USB). Some extra notes for bulk LiveUSB creation that does not require a USB-stick-making-USB-stick:

1. Download the ISO file
1. Format the USB stick so that it has one 550 MB FAT32 "ESP" + 2.1 GiB EXT4 "Ubuntu" + rest of USB EXT4 "casper-rw"
1. Use unetbootin to install it onto the Ubuntu partition and remove casper-rw file from Ubuntu partition, or just copy over all files from the ISO when it's mounted
1. Copy the EFI directory to ESP
1. Change ESP/boot/grub/grub.cfg to have the string "persistent"
1. Run on a computer to run the bionic script in this repo

All of this except for the last step is implemented in `mkusb.sh`. Run it like:
```
mkusb.sh ubuntu.iso /dev/sdx
```
It will ask you to confirm and ask for your root password when needed.

For the last step, boot into the live medium, and run:

```
sudo apt update && sudo apt install -y git && git clone https://github.com/geoscripting-wur/InstallLinuxScript
```

Then follow the instructions in `../README.md`.
