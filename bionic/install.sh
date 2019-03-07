#!/bin/bash
# Script for installing necessary software on an Ubuntu 18.04 VM
# Common part for all Bionic-based OSs, but not OSGeo Live

# Disable automatic updates, those can break everything
sudo sed -i 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/' /etc/apt/apt.conf.d/20auto-upgrades
sudo sed -i 's/APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "0";/' /etc/apt/apt.conf.d/20auto-upgrades

# DM: QGIS 3
sudo apt-key adv --keyserver https://qgis.org/downloads/qgis-2017.gpg.key --recv-keys CAEB3DC3BDF7FB45
sudo add-apt-repository "https://qgis.org/ubuntu"

# DM: Update
sudo apt update
sudo apt upgrade -y

# DS: Install software
sudo apt install -y mesa-utils gdebi-core curl spatialite-gui spatialite-bin gdal-bin git-gui qgis python-qgis grass

# DM: Add Git GUI into the menu
sudo mkdir /usr/local/share/applications/
sudo cp ../common/git-gui.desktop /usr/local/share/applications/

# DM: Install R from the CRAN repository and RKWard
#sudo add-apt-repository "deb http://cloud.r-project.org/bin/linux/ubuntu/ xenial-cran35/"
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
#sudo apt update
# DM: RKWard also depends on some KDE libraries, not sure which ones, but it works if you add `dolphin breeze-icon-theme oxygen-icon-theme`
# DM: Might also need qt5ct and QT_QPA_PLATFORMTHEME=qt5ct and gnome-icon-theme
sudo apt install -y r-base r-base-dev rkward oxygen-icon-theme

# Install requirements for packages not part of the CRAN distribution
sudo apt install -y libgdal-dev libgeos-dev libproj-dev libxml2-dev libcurl4-openssl-dev libssl-dev libudunits2-dev liblwgeom-dev

# PostGIS
#sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdg main"
#sudo apt-key adv --keyserver http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc --recv-keys ACCC4CF8
#sudo apt update
sudo apt install -y postgresql-10-postgis-2.4 pgadmin3 postgresql-contrib postgresql-10-postgis-2.4-scripts postgresql-server-dev-10 libpq-dev
# DM: Create a user and a database with these credentials
PGUSER="geoscripting"
export PGPASSWORD="geoscripting"
PGDB="geoscripting"
sudo -u postgres psql -c "CREATE ROLE ${PGUSER} WITH LOGIN CREATEDB"
sudo -u postgres psql -c "ALTER ROLE ${PGUSER} WITH PASSWORD '${PGPASSWORD}'"
psql -h localhost -U ${PGUSER} -d postgres -c "CREATE DATABASE ${PGDB}"
sudo -u postgres psql -d ${PGDB} -c "CREATE EXTENSION postgis;"

# RStudio and Nbgrader
pushd ../common
bash install-rstudio.sh
sh install-nbgrader.sh
popd
