#!/bin/bash
# Creates persistent live USB sticks

# $1: ISO image
ISOFILE=$1
# $2: path to block device to overwrite (i.e. /dev/sdx, not a partition)
TARGETDEV=$2
ISOMOUNT="/tmp/geoscripting-livecd"
ESPMOUNT="/tmp/geoscripting-esp"
UBUMOUNT="/tmp/geoscripting-ubuntu"

## Sanity checks
# Required non-root programs
file --help > /dev/null || exit 1
awk --help > /dev/null || exit 1
grep --help > /dev/null || exit 1
stat --help > /dev/null || exit 1
# Inputs
isomimetype=$(file -b --mime-type "$ISOFILE")
if [[ $isomimetype != "application/x-iso9660-image" && $isomimetype != "application/octet-stream" ]]; then
    echo "$ISOFILE does not exist or is not an ISO image"
    exit 1
fi
if [[ $(file -b --mime-type "$TARGETDEV") != "inode/blockdevice" ]]; then
    echo "$TARGETDEV does not exist or is not a block device"
    exit 1
fi
if [[ $(stat --printf="%s" "$ISOFILE") -gt 2936012800 ]]; then
    echo "ISO file too large to fit into the partition to be created. Please adjust partitions.txt and this script accordingly."
    exit 1
fi
# Required root programs
sudo sfdisk --help > /dev/null || exit 1
sudo lsblk --help > /dev/null || exit 1
# Prompt user
echo "Will write $ISOFILE into $TARGETDEV. This will OVERWRITE $TARGETDEV. Make sure you know what you are doing. Note: target should be a whole block device, not partition. It should not be mounted. If you are not sure, press Ctrl+C now!"
read

## Partition the USB stick
# Partition according to the template, wiping if needed
sudo sfdisk --wipe always "$TARGETDEV" < partitions.txt || exit 1

# Wait to make sure that the changes have been written
sudo partprobe "$TARGETDEV"
echo 1 | sudo tee /sys/block/$(basename ${TARGETDEV})/device/rescan
sudo sync "$TARGETDEV"
# And just to be on the safe side, wait one more second
sleep 1

# Find our written partitions
PARTBLK=$(sudo lsblk -nlp --output NAME,PARTLABEL "$TARGETDEV")
ESPDEV=$(grep ESP <<< $PARTBLK       | awk '{print $1}')
if [[ ${ESPDEV} == "" ]]; then
  ESPDEV=${TARGETDEV}1
fi
UBUDEV=$(grep Ubuntu <<< $PARTBLK    | awk '{print $1}')
if [[ ${UBUDEV} == "" ]]; then
  UBUDEV=${TARGETDEV}2
fi
CRWDEV=$(grep casper-rw <<< $PARTBLK | awk '{print $1}')
if [[ ${CRWDEV} == "" ]]; then
  CRWDEV=${TARGETDEV}3
fi

## Make appropriate file systems
sudo mkfs.vfat -F 32 -n ESP "$ESPDEV" || exit 1
sudo mkfs.ext4 -L Ubuntu "$UBUDEV" || exit 1
sudo mkfs.ext4 -L casper-rw "$CRWDEV" || exit 1

## Copy over the contents of the LiveCD
# Mount our LiveCD
if [[ ! -f "$ISOMOUNT" ]]; then
    mkdir "$ISOMOUNT"
fi
sudo mount -o loop "$ISOFILE" "$ISOMOUNT" || exit 1

## Set up ESP
# Mount the ESP
if [[ ! -f "$ESPMOUNT" ]]; then
    mkdir "$ESPMOUNT"
fi
sudo mount "$ESPDEV" "$ESPMOUNT" || exit 1
# Copy to ESP
sudo rsync -av "$ISOMOUNT/EFI" "$ESPMOUNT/" || exit 1
# Unmount ESP
sudo umount "$ESPMOUNT"
rmdir "$ESPMOUNT"

## Set up Ubuntu
# Mount
if [[ ! -f "$UBUMOUNT" ]]; then
    mkdir "$UBUMOUNT"
fi
sudo mount "$UBUDEV" "$UBUMOUNT" || exit 1
# Copy
sudo rsync -av "$ISOMOUNT/" "$UBUMOUNT" || exit 1
# Add "persistent" to GRUB config
sudo sed -i 's/quiet splash/persistent quiet splash/' "$UBUMOUNT"/boot/grub/grub.cfg || exit 1

## Clean up
# Unmount Ubuntu
sudo umount "$UBUMOUNT"
rmdir "$UBUMOUNT"
# Unmount LiveCD
sudo umount "$ISOMOUNT"
rmdir "$ISOMOUNT"

echo "Persistent LiveCD created successfully! You can now unplug the USB device, boot from it and run the InstallLinuxScript."
