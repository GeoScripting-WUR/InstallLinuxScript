#!/bin/bash

# Create partitions

sudo fdisk /dev/nvme0n1

# Here, create the partitions as per the readme
# g
# n
# To make a gap, either make a new partition with a large number and remove it
# later, or use a sector number, such as 300000000 (150 GB mark for 512B sectors).
# t
# Set types to EFI System, Linux root (x86-64), Linux home
# w

# Repeat for any other disks, but don't make another EFI SYSTEM

sudo fdisk /dev/nvme1n1

# Create the EFI SYSTEM partition

sudo mkfs.fat -F 32 -n ESP /dev/nvme0n1p1

# Create btrfs on the new partitions
# NOTE: This breaks ubiquity in 22.04.1. Workaround: do a single btrfs volume
# and then btrfs dev add && btrfs fi balance start -dconvert=raid1 -mconvert=raid1

sudo mkfs.btrfs -L Ubuntu -d raid1 /dev/nvme0n1p2 /dev/nvme1n1p1
sudo mkfs.btrfs -L Home   -d raid1 /dev/nvme0n1p3 /dev/nvme1n1p2

# Load them

sudo mkdir /mnt/Ubuntu /mnt/Home

sudo mount /dev/nvme0n1p2 /mnt/Ubuntu
sudo mount /dev/nvme0n1p3 /mnt/Home

pushd /mnt/Ubuntu
sudo btrfs subvol create @
sudo btrfs subvol set-default @
cd '@'
sudo btrfs subvol create var
sudo btrfs subvol create tmp
popd

pushd /mnt/Home
sudo btrfs subvol create @
sudo btrfs subvol set-default @
popd

sudo umount /mnt/Ubuntu /mnt/Home

# Make data drives

# Make swap partitions, backup partition and data partitions
sudo fdisk /dev/sda
sudo fdisk /dev/sdb

# Set up swap
sudo mkswap -L SwapA /dev/sda1
sudo mkswap -L SwapB /dev/sdb1

# Set up data
sudo mkdir /mnt/DATA
sudo mkfs.btrfs -L Data /dev/sda3 /dev/sdb2
sudo mount /dev/sda3 /mnt/DATA
sudo nano /mnt/DATA/README.TXT # Write text about this drive
sudo chmod 777 /mnt/DATA/
sudo umount /mnt/DATA

# Set up archive
sudo mkfs.btrfs -L Backup /dev/sda2
sudo mkdir /mnt/archive
sudo mount /dev/sda2 /mnt/archive
sudo mkdir -p /mnt/archive/snapshots/root /mnt/archive/snapshots/home
sudo umount /mnt/archive
