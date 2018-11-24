# InstallLinuxScript
Repository stores configurations and bash scripts to install all necessary software and modules on an Ubuntu-based OS for Geo-scripting.
Another script removes unnecessary software.

The goal of the script is to prepare a clean Ubuntu OS for all students and staff during Geo-Scripting.
There are several supported OSs and scenarios, from most to least preferred:

1. VMWare Horizon VDI provided by the IT department. Depending on the OS version, see directories `vdi-<codename>`.
2. OSGeo Live. See directories `osgeo-<codename>`.
3. Vanilla Ubuntu LiveCD. See directories `<codename>` (with no prefix).

In these directories, the script called `install.sh` is what installs the necessary software.
Optionally, you can run `free-space.sh` to reclaim some space by removing unnecessary software.
Always read through the associated readmes and scripts before running them!

This script has been made for Geo-scripting course in 2017 by Dainius Masiliunas and David Swinkels. 
It should be updated every year to have correct versions and latest software. 
The installation process might change over the years and can still be improved :)
Feel free to change installation script, but only install stable versions from trusted repositories! 
