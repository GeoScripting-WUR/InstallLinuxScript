#!/bin/bash
# Script for installing necessary software on an Ubuntu 18.04 VM
# Common part for all Bionic-based OSs, but not OSGeo Live

# Disable automatic updates, those can break everything
sudo sed -i 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/' /etc/apt/apt.conf.d/20auto-upgrades
sudo sed -i 's/APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "0";/' /etc/apt/apt.conf.d/20auto-upgrades

# DM: QGIS 3
sudo apt-key adv --keyserver https://qgis.org/downloads/qgis-2019.gpg.key --recv-keys 51F523511C7028C3
sudo add-apt-repository "https://qgis.org/ubuntu"

# DM: R >3.5
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/"

# DM: Update
sudo apt update
sudo apt upgrade -y

# DS: Install software
sudo apt install -y mesa-utils gdebi-core curl spatialite-gui spatialite-bin gdal-bin git-gui qgis grass

# DM: Add Git GUI into the menu
sudo mkdir /usr/local/share/applications/
sudo cp ../common/git-gui.desktop /usr/local/share/applications/

# DM: Install R and RKWard
sudo apt install -y r-base r-base-dev rkward oxygen-icon-theme

# Install requirements for packages not part of the CRAN distribution
sudo apt install -y libgdal-dev libgeos-dev libproj-dev libxml2-dev libcurl4-openssl-dev libssl-dev libudunits2-dev liblwgeom-dev

# PostGIS
sudo apt install -y postgis pgadmin3 postgresql-contrib postgresql-server-dev-10
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
