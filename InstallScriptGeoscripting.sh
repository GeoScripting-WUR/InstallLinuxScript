#!/bin/sh
# Script for installing necessary software on an Ubuntu 16.04 VM

# DM: GDAL, GEOS, Fiona, SpatiaLite
sudo add-apt-repository ppa:ubuntugis/ppa
# DM: RKWard compiled against CRAN
sudo add-apt-repository ppa:rkward-devel/rkward-stable-cran
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sshfs mesa-utils manpages firefox xarchiver spyder gdebi-core
sudo apt-get install spatialite-gui spatialite-bin gdal-bin git-gui

# DM: Install R from the CRAN repository
sudo apt-get install r-base r-base-dev rkward
# add manual change in sources.list

# RStudio installation
RSTUDIO_VERSION="1.1.383"
wget https://download1.rstudio.org/rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
sudo gdebi -n rrstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
rm rstudio-xenial-${RSTUDIO_VERSION}-amd64
# NOTE: RKWard is built against the default R packages. It needs to be installed from a PPA for the linked-to-CRAN version.
# NOTE2: RStudio is installed from rstudio repository


# Install requirements for packages not part of the CRAN distribution
sudo apt-get install libgdal-dev libgeos-dev libproj-dev libxml2-dev libcurl4-openssl-dev libssl-dev libudunits2-dev liblwgeom-dev
# Source-install "raster", "googleVis", "lubridate", "leaflet".
# Make sure to use a directory common to RStudio and RKWard: RKWard settings
# ~/R/x86_64-pc-linux-gnu-library/3.2
sudo apt-get install r-cran-spatstat r-cran-jsonlite r-cran-zoo r-cran-magrittr r-cran-stringr
sudo apt-get install r-cran-colorspace r-cran-yaml r-cran-digest r-cran-rcpp r-cran-mime r-cran-dichromat r-cran-plyr r-cran-munsell r-cran-labeling r-cran-base64enc r-cran-rcolorbrewer r-cran-scales r-cran-sp

# QGIS
sudo add-apt-repository http://qgis.org/debian
wget -O - http://qgis.org/downloads/qgis-2017.gpg.key | gpg --import
gpg --fingerprint CAEB3DC3BDF7FB45
gpg --export --armor CAEB3DC3BDF7FB45 | sudo apt-key add -
sudo apt-get update && sudo apt-get install qgis python-qgis  

# Google Earth
pushd /tmp
mkdir google-earth && cd google-earth
sudo apt-get install lsb-core lsb-base lsb-invalid-mta
wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
sudo dpkg -i google-earth-stable*.deb
popd

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
