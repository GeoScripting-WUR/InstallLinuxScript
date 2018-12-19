# InstallLinuxScript
Repository stores configurations and bash scripts to install all necessary software and modules on an Ubuntu-based OS for Geo-scripting. There are two stages of installation: system-wide (requires root) and user.

The goal of the script is to prepare a clean Ubuntu OS for all students and staff during Geo-Scripting.
There are several supported OSs and scenarios, from most to least preferred:

1. VMWare Horizon VDI provided by the IT department. Depending on the OS version, see directories `vdi-<codename>`. These are only interesting for staff who prepare a VDI image.
2. OSGeo Live. See directories `osgeo-<codename>`.
3. Vanilla Ubuntu LiveCD. See directories `<codename>` (with no prefix).

In these directories, the script called `install.sh` is what installs the necessary software system-wide.
Next, the script `user/install.sh` installs all the user software. This is the only thing that regular users need to run on VDIs, as we can't (easily) preload software onto user directories and user config files.

When preparing a VDI image, run `free-space.sh` to reclaim some space by removing unnecessary software.

Always read through the associated readmes and scripts before running them!

These scripts were made for Geo-scripting course in 2017 by Dainius Masiliunas and David Swinkels, and updated in 2018. 
It should be updated every year to have correct versions and latest software. 
The installation process might change over the years and can still be improved :)
Feel free to change installation script, but only install stable versions from trusted repositories! 
