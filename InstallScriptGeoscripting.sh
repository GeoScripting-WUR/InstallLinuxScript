#!/bin/sh
# Script for installing necessary software on an Ubuntu 16.04 VM

# DM: Update
sudo apt-get update
sudo apt-get upgrade

# DM: Install Xfce
sudo apt-get install xubuntu-desktop
# DM: Disable shutdown/reboot buttons
sudo mkdir /etc/xdg/xfce4/kiosk
sudo cp kioskrc /etc/xdg/xfce4/kiosk
# DM: Set Xfce as default
sudo sed -i "s/user-session=ubuntu/user-session=xubuntu/" /etc/lightdm/lightdm.conf

# DM: GDAL, GEOS, Fiona, SpatiaLite
sudo add-apt-repository ppa:ubuntugis/ppa
# DM: RKWard compiled against CRAN
sudo add-apt-repository ppa:rkward-devel/rkward-stable-cran

sudo apt-get install sshfs mesa-utils manpages firefox xarchiver spyder gdebi-core
sudo apt-get install spatialite-gui spatialite-bin gdal-bin git-gui

# DM: Install R from the CRAN repository and RKWard
sudo add-apt-repository "deb http://cran-mirror.cs.uu.nl/bin/linux/ubuntu xenial/"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update && sudo apt-get install r-base r-base-dev rkward

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
sudo apt-get install r-cran-spatstat r-cran-jsonlite r-cran-zoo r-cran-magrittr r-cran-stringr
sudo apt-get install r-cran-colorspace r-cran-yaml r-cran-digest r-cran-rcpp r-cran-mime r-cran-dichromat r-cran-plyr r-cran-munsell r-cran-labeling r-cran-base64enc r-cran-rcolorbrewer r-cran-scales r-cran-sp

# QGIS
# DM: NOTE: Check if the key changes in 2018!
sudo add-apt-repository http://qgis.org/debian
sudo apt-key adv --keyserver http://qgis.org/downloads/qgis-2017.gpg.key --recv-keys CAEB3DC3BDF7FB45
sudo apt-get update && sudo apt-get install qgis python-qgis  

# Google Earth
mkdir /tmp/google-earth
pushd /tmp/google-earth
sudo apt-get install lsb-core lsb-base lsb-invalid-mta
wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
sudo dpkg -i google-earth-stable*.deb
popd
rm -r /tmp/google-earth

# PostGIS
sudo add-apt-repository http://apt.postgresql.org/pub/repos/apt
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-9.5-postgis-2.2 pgadmin3 postgresql-contrib-9.5 postgresql-9.5-postgis-2.2-scripts postgresql-server-dev-9.5 libpq-dev

# Remove rsyslog, already have journald
sudo systemctl disable rsyslog
sudo systemctl stop rsyslog syslog.socket
sudo apt-get purge --auto-remove rsyslog

sudo apt autoremove

# Settings: Mousepad should have View -> Color Scheme set
