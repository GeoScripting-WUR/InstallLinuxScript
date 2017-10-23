#!/bin/sh
# Script for installing necessary software on an Ubuntu 16.04 VM

# DM: Utility packages
sudo add-apt-repository ppa:ubuntugis/ppa
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sshfs mesa-utils manpages firefox xarchiver
sudo apt-get install qgis spatialite-gui spatialite-bin gdal-bin

# DM: Install R from the CRAN repository

sudo apt-get install r-base r-base-dev rkward spyder
# NOTE: RKWard is built against the default R packages. It needs to be installed from a PPA for the linked-to-CRAN version.

# Install requirements for packages not part of the CRAN distribution
sudo apt-get install libgdal-dev
# Source-install "raster", "googleVis", "lubridate", "leaflet".
# Make sure to use a directory common to RStudio and RKWard: RKWard settings
# ~/R/x86_64-pc-linux-gnu-library/3.2
sudo apt-get install r-cran-spatstat r-cran-jsonlite r-cran-zoo r-cran-magrittr r-cran-stringr
sudo apt-get install r-cran-colorspace r-cran-yaml r-cran-digest r-cran-rcpp r-cran-mime r-cran-dichromat r-cran-plyr r-cran-munsell r-cran-labeling r-cran-base64enc r-cran-rcolorbrewer r-cran-scales r-cran-sp

# Remove rsyslog, already have journald
sudo systemctl disable rsyslog
sudo systemctl stop rsyslog syslog.socket
sudo apt-get purge --auto-remove rsyslog

# Settings: Mousepad should have View -> Color Scheme set
