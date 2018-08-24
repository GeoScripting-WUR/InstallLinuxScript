# InstallLinuxScript
Repository stores configurations and a bash script to install all necessary software and modules on an Ubuntu OS for Geo-scripting.
Another script removes unnecessary software.

The goal of the script is to prepare a clean Ubuntu OS for all students and staff during Geo-Scripting.
There are some steps through this process:
1. The IT Servicedesk of Wageningen University gives a clean Ubuntu OS via VDI or VM
2. Run InstallScriptGeoscripting.sh
3. Reboot Ubuntu OS
4. In case autologin does not work; username is WUR account (e.g. swink019) and password is WUR password
5. Run CleanUnnecessarySoftware.sh
6. Test if all lessons and software work correctly with latest versions. If software is updated or added, update InstallScriptGeoscripting.sh.
7. Run step 2,3,4 on a new clean Ubuntu OS via VDI or VM to create default Geoscripting-Ubuntu image
8. Tell IT Servicedesk which Ubuntu VDI has the default Geoscripting-Ubuntu image
9. IT Servicedesk copies default Geoscripting-Ubuntu image of Ubuntu VDI and shares it to all students and staff

This script has been made for Geo-scripting course in 2017 by Dainius Masiliunas and David Swinkels. 
It should be updated every year to have correct versions and latest software. 
The installation process might change over the years and can still be improved :)
Feel free to change installation script, but only install stable versions from trusted repositories! 
