#!/bin/bash
# Script for installing necessary software on an Ubuntu 16.04 VM
# Common part for all Xenial-based OSs, but not OSGeo Live

# DM: GDAL, GEOS, Fiona, SpatiaLite
sudo add-apt-repository ppa:ubuntugis/ppa
# DM: RKWard compiled against CRAN
sudo add-apt-repository ppa:rkward-devel/rkward-stable-cran

# DM: Update
sudo apt update
sudo apt upgrade -y

# DS: Install software
sudo apt install -y sshfs mesa-utils manpages firefox gdebi-core curl
sudo apt install -y spatialite-gui spatialite-bin gdal-bin git-gui qgis python-qgis

# DM: Add Git GUI into the menu
sudo mkdir /usr/local/share/applications/
sudo cp ../common/git-gui.desktop /usr/local/share/applications/

# DS: Install Grass and hold version to 7.0.3 
#sudo apt install -y grass=7.0.3-1build1 grass-core=7.0.3-1build1 grass-doc=7.0.3-1build1 grass-gui=7.0.3-1build1
#sudo apt-mark hold grass grass-gui grass-doc grass-core

# DM: Install R from the CRAN repository and RKWard
sudo add-apt-repository "deb http://cloud.r-project.org/bin/linux/ubuntu/ xenial-cran35/"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# DM: RKWard also depends on some KDE libraries, not sure which ones, but it works if you add `dolphin breeze-icon-theme oxygen-icon-theme`
# DM: Might also need qt5ct and QT_QPA_PLATFORMTHEME=qt5ct and gnome-icon-theme
sudo apt update && sudo apt install -y r-base r-base-dev rkward oxygen-icon-theme

# Install requirements for packages not part of the CRAN distribution
sudo apt install -y libgdal-dev libgeos-dev libproj-dev libxml2-dev libcurl4-openssl-dev libssl-dev libudunits2-dev liblwgeom-dev

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

# RStudio and Nbgrader
pushd ../common
bash install-rstudio.sh
sh install-nbgrader.sh
popd
