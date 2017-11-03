#!/bin/sh
# Script for installing necessary software on an Ubuntu 16.04 VM

# DM: VMWare Horizon settings: do not inherit keyboard layouts
sudo sed -i "s/#KeyboardLayoutSync=FALSE/KeyboardLayoutSync=FALSE/" /etc/vmware/viewagent-custom.conf
# DM: Set sudo timeout to an hour
sudo sed -i "s/Defaults\tenv_reset/Defaults\tenv_reset,timestamp_timeout=60/" /etc/sudoers

# DM: Update
sudo apt update
sudo apt upgrade

# DM: Install Xfce
sudo apt install xubuntu-desktop
# DM: Disable shutdown/reboot buttons
sudo mkdir /etc/xdg/xfce4/kiosk
sudo cp kioskrc /etc/xdg/xfce4/kiosk
# DM: Set default panel layout
sudo cp xfce4-panel.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/
# DM: Set Xfce as default in LightDM
sudo sed -i "s/user-session=ubuntu/user-session=xubuntu/" /etc/lightdm/lightdm.conf

# DM: GDAL, GEOS, Fiona, SpatiaLite
sudo add-apt-repository ppa:ubuntugis/ppa
# DM: RKWard compiled against CRAN
sudo add-apt-repository ppa:rkward-devel/rkward-stable-cran

sudo apt install sshfs mesa-utils manpages firefox spyder gdebi-core
sudo apt install spatialite-gui spatialite-bin gdal-bin git-gui qgis python-qgis

# DM: Add Git GUI into the menu
sudo mkdir /usr/local/share/applications/
sudo cp git-gui.desktop /usr/local/share/applications/

# DM: Install R from the CRAN repository and RKWard
sudo add-apt-repository "deb http://cran-mirror.cs.uu.nl/bin/linux/ubuntu xenial/"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt update && sudo apt install r-base r-base-dev rkward

# RStudio installation
RSTUDIO_VERSION="1.1.383"
pushd /tmp
wget https://download1.rstudio.org/rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
sudo gdebi -n rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
rm rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
popd

# Install requirements for packages not part of the CRAN distribution
sudo apt-get install libgdal-dev libgeos-dev libproj-dev libxml2-dev libcurl4-openssl-dev libssl-dev libudunits2-dev liblwgeom-dev
# Source-install "raster", "googleVis", "lubridate", "leaflet".
# Make sure to use a directory common to RStudio and RKWard: RKWard settings
# ~/R/x86_64-pc-linux-gnu-library/3.2
sudo apt install r-cran-spatstat r-cran-jsonlite r-cran-zoo r-cran-magrittr r-cran-stringr r-cran-ggplot2
sudo apt install r-cran-colorspace r-cran-yaml r-cran-digest r-cran-rcpp r-cran-mime r-cran-dichromat r-cran-plyr r-cran-munsell r-cran-labeling r-cran-base64enc r-cran-rcolorbrewer r-cran-scales r-cran-sp

# QGIS
# DM: NOTE: Check if the key changes in 2018!
#sudo add-apt-repository http://qgis.org/debian
#sudo apt-key adv --keyserver http://qgis.org/downloads/qgis-2017.gpg.key --recv-keys CAEB3DC3BDF7FB45
#sudo apt-get update && sudo apt-get install qgis python-qgis  

# PostGIS
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdg main"
sudo apt-key adv --keyserver http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc --recv-keys ACCC4CF8
sudo apt-get update
sudo apt-get install postgresql-9.5-postgis-2.2 pgadmin3 postgresql-contrib-9.5 postgresql-9.5-postgis-2.2-scripts postgresql-server-dev-9.5 libpq-dev
# DM: Create a user and a database with these credentials
PGUSER="geoscripting"
PGPASS="geoscripting"
PGDB="geoscripting"
sudo -u postgres psql -c "CREATE ROLE ${PGUSER} WITH LOGIN CREATEDB"
sudo -u postgres psql -c "ALTER ROLE ${PGUSER} WITH PASSWORD '${PGPASSWORD}'"
psql -h localhost -U ${PGUSER} -d postgres -c "CREATE DATABASE ${PGDB}"
sudo -u postgres psql -d ${PGDB} -c "CREATE EXTENSION postgis;"
# DM: New tables can be added with:
#psql -h localhost -U ${PGUSER} -d ${PGDB} -f table_creation_statements.sql

# Remove unnecessary software

# Remove rsyslog, already have journald; snapd is for servers; don't need two browsers
# Vim is confusing and there is nano already, unity and gnome-flashback no longer needed
# Also remove gnome utilities with Xfce equivalents and games
sudo systemctl disable rsyslog snapd
sudo systemctl stop rsyslog syslog.socket snapd snapd.service
sudo apt purge --auto-remove indicator-session indicator-applet indicator-applet-complete indicator-application indicator-bluetooth indicator-datetime indicator-keyboard indicator-messages indicator-power indicator-printers indicator-sound \
  rsyslog snapd chromium-browser vim vim-common gnome-user-guide unity gnome-flashback gedit nautilus aisleriot gnome-mahjongg gnome-mines gnome-sudoku shotwell simple-scan eog usb-creator-common gnome-system-monitor gnome-terminal \
  blueman evolution-data-server network-manager-gnome network-manager-pptp-gnome xscreensaver gnome-screensaver light-locker

# Clean all old kernels
sudo apt install byobu
sudo purge-old-kernels --keep 1
sudo apt purge --auto-remove byobu

# Remove unneeded packages and clean cache
sudo apt autoremove
sudo apt-get clean

# Settings: Mousepad should have View -> Color Scheme set
