#!/bin/bash
# Script to install RStudio
# This is generic across releases as long as RStudio doesn't make any changes in distribution
# (they did between 15.10 and 16.04, so this is valid since 16.04)

RSTUDIO_VERSION=${1:-"1.1.463"}
pushd /tmp
wget https://download1.rstudio.org/rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
sudo gdebi -n rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
rm rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
popd
