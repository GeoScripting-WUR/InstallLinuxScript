#!/bin/bash
# Script to install RStudio
# For bionic specifically, for xenial see ../common/install-rstudio.sh

RSTUDIO_VERSION=${1:-"1.2.5033"}
pushd /tmp
wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-${RSTUDIO_VERSION}-amd64.deb
sudo gdebi -n rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
rm rstudio-xenial-${RSTUDIO_VERSION}-amd64.deb
popd
