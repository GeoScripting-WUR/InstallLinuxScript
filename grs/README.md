# Extra install scripts for regular GRS servers

## Topology

BTRFS is used as the mail file system, due to its native support for RAID and
snapshot capabilities, which is very important for backups.

GPT is used as the partition table format. There is always one
FAT32 boot partition for EFI SYSTEM, on the first SSD, with 500 MiB space,
labelled ESP. This is the space limit for creating FAT32 and not FAT16.

Home and root partitions are divided, to prevent users from filling up the disk.
`/tmp` is mounted as tmpfs, to prevent users from filling up the system disk in
another way.

The root partition is on an SSD, labelled `Ubuntu` and is BTRFS with RAID1
(if we have two SSDs, otherwise regular, because we can always regenerate
this partition.) It has a subvolume `@` that contains everything else.
This subvolume is set as the default subvolume. This is needed because if
something goes wrong in `/` and we want to restore a previous snapshot,
without this subvolume we would need to retain the old broken `/`.
With it, we can do:
```bash
mount -o subvol=/ /dev/nvme... /mnt/root
mv /mnt/root/@ /mnt/root/broken
btrfs subvol snapshot /mnt/root/broken/.snapshots/number/snapshot /mnt/root/@
rm -r /mnt/root/broken
```

`@` has subvolumes for `/var` (avoid snapshots of logs),
`/tmp` (this should already be handled by tmpfs, but just in case it somehow gets
unmounted). `/.snapshots` is created automatically by snapper.

In between the root and the home partitions is an empty space for provisioning
(5% of the SSD). This is both for the SSD controller and in case we critically
run out of space on either the root or the home partition.

The home partition is also on an SSD and is labelled `Home`, also on RAID1.
Likewise it has a default subvolume `@`.
It might have quota enabled, depending on the maximum number of users.

One HDD has a partition labelled `Backup` that is big enough to store at least
one copy of the SSD data. This is mounted as `/mnt/archive` and includes
a directory `snapshots` with two subdirectories, one for `root` (Ubuntu) and one
for `home`. There may be more if there are any backed-up data partitions.

The HDDs also have `swap` partitions that add up to the square root of the RAM
(e.g. with 128 GiB RAM we have 12 GiB swap, across two HDDs that is 6 GiB each).

The rest of the HDD space is used for non-backed-up bulk storage, such as
satellite imagery. This can relatively quickly be regenerated in case of data
loss. This is a BTRFS partition, potentially with RAID0 if it is across drives.
It is mounted at `/mnt/DATA`, and is read-write to everyone. Each user is
supposed to create a subdirectory with their username and write their files
there. If there is backup, or a partial backup, then this partition contains
two subvolumes: `backup` and `nobackup`, which then contain directories for each
user.

Snapper is used to automatically create snapshots regularly of both the root and
home partitions, and any backed up bulk storage.

## Scripts

The scripts in this directory are for reference only, they are not to be run
directly. This is because disk space and topolgy always varies between computers.
But it gives a quick reference of what needs to be run to get a computer up and
running.

The scripts are ordered by precedence. They were last updated for Ubuntu Jammy.
