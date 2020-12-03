#!/bin/bash
# Script to install RStudio
# For bionic specifically, for xenial see ../common/install-rstudio.sh

RSTUDIO_VERSION=${1:-"1.3.1073"}
DEBFILE=rstudio-${RSTUDIO_VERSION}-amd64.deb
pushd /tmp
wget https://download1.rstudio.org/desktop/bionic/amd64/${DEBFILE}
sudo gdebi -n ${DEBFILE}
rm ${DEBFILE}
popd
