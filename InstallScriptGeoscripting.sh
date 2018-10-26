#!/bin/sh
# Script for installing necessary software on an Ubuntu 16.04 VM

# WARNING: You should manually run an apt update && apt upgrade before this in an ssh session! Ideally also reboot between that and running this script.

# DM: VMWare Horizon settings: do not inherit keyboard layouts
sudo sed -i "s/#KeyboardLayoutSync=FALSE/KeyboardLayoutSync=FALSE/" /etc/vmware/viewagent-custom.conf
# DM: Set to use GNOME Flashback
sudo sed -i "s/#UseGnomeFlashback=TRUE/UseGnomeFlashback=TRUE/" /etc/vmware/viewagent-custom.conf
echo "SSODesktopType=UseGnomeFlashback" | sudo tee -a /etc/vmware/viewagent-custom.conf
# DM: Set sudo timeout to an hour
sudo sed -i "s/Defaults\tenv_reset/Defaults\tenv_reset,timestamp_timeout=60/" /etc/sudoers
# DM: Disable prompt to upgrade to 18.04, that would be disastrous for current VMWare version
sudo sed -i "s/Prompt=.*/Prompt=never/" /etc/update-manager/release-upgrades

# DM: Update
sudo apt update
sudo apt-mark hold samba
sudo apt upgrade # Use SSH to upgrade and keep local file for Samba

# DM: GNOME Fallback options instead, based on dconf
sudo cp user /etc/dconf/profile/
sudo mkdir /etc/dconf/db/geoscripting.d
sudo cp 10-geoscripting /etc/dconf/db/geoscripting.d
sudo dconf update

# DM: GDAL, GEOS, Fiona, SpatiaLite
sudo add-apt-repository ppa:ubuntugis/ppa
# DM: RKWard compiled against CRAN
sudo add-apt-repository ppa:rkward-devel/rkward-stable-cran

# DS: Upgrade software from repositories
sudo apt update
sudo apt upgrade

# DS: Install software
sudo apt install -y sshfs mesa-utils manpages firefox gdebi-core curl
sudo apt install -y spatialite-gui spatialite-bin gdal-bin git-gui qgis python-qgis

# DS: Install Grass and hold version to 7.0.3 
sudo apt install -y grass=7.0.3-1build1 grass-core=7.0.3-1build1 grass-doc=7.0.3-1build1 grass-gui=7.0.3-1build1
sudo apt-mark hold grass grass-gui grass-doc grass-core

# DM: Add Git GUI into the menu
sudo mkdir /usr/local/share/applications/
sudo cp git-gui.desktop /usr/local/share/applications/

# DM: Install R from the CRAN repository and RKWard
sudo add-apt-repository "deb http://cloud.r-project.org/bin/linux/ubuntu/ xenial/"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt update && sudo apt install -y r-base r-base-dev rkward

# RStudio installation
RSTUDIO_VERSION="1.1.456"
pushd /tmp
wget https://download1.rstudio.org/rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
sudo gdebi -n rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
rm rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
popd

# Install requirements for packages not part of the CRAN distribution
sudo apt install -y libgdal-dev libgeos-dev libproj-dev libxml2-dev libcurl4-openssl-dev libssl-dev libudunits2-dev liblwgeom-dev
# Make sure to use a directory common to RStudio and RKWard: RKWard settings
# ~/R/x86_64-pc-linux-gnu-library/3.2
sudo apt install -y r-cran-spatstat r-cran-jsonlite r-cran-zoo r-cran-magrittr r-cran-stringr r-cran-ggplot2
sudo apt install -y r-cran-colorspace r-cran-yaml r-cran-digest r-cran-rcpp r-cran-mime r-cran-dichromat r-cran-plyr r-cran-munsell r-cran-labeling r-cran-base64enc r-cran-rcolorbrewer r-cran-scales r-cran-sp

# PostGIS
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdg main"
sudo apt-key adv --keyserver http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc --recv-keys ACCC4CF8
sudo apt update
sudo apt install -y postgresql-9.5-postgis-2.2 pgadmin3 postgresql-contrib-9.5 postgresql-9.5-postgis-2.2-scripts postgresql-server-dev-9.5 libpq-dev
# DM: Create a user and a database with these credentials
PGUSER="geoscripting"
export PGPASSWORD="geoscripting"
PGDB="geoscripting"
sudo -u postgres psql -c "CREATE ROLE ${PGUSER} WITH LOGIN CREATEDB"
sudo -u postgres psql -c "ALTER ROLE ${PGUSER} WITH PASSWORD '${PGPASSWORD}'"
psql -h localhost -U ${PGUSER} -d postgres -c "CREATE DATABASE ${PGDB}"
sudo -u postgres psql -d ${PGDB} -c "CREATE EXTENSION postgis;"

# Nbgrader
# User needs to install nbgrader from conda-forge channel via conda
sudo mkdir -p /srv/nbgrader/exchange
sudo chmod ugo+rw /srv/nbgrader/exchange
sudo mkdir -p /etc/jupyter
sudo echo 'c = get_config()' >> /etc/jupyter/nbgrader_config.py
sudo echo 'c.Exchange.course_id = "geoscripting"' >> /etc/jupyter/nbgrader_config.py

echo "Please restart and then run ./CleanUnnecessarySoftware.sh!"

# Settings: Mousepad should have View -> Color Scheme set
