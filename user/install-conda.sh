#!/bin/sh

MINICONDA_VERSION="Miniconda3-latest-Linux-x86_64"
pushd /tmp
wget https://repo.continuum.io/miniconda/${MINICONDA_VERSION}.sh
## Unattended install, will put into ~/miniconda3
bash ${MINICONDA_VERSION}.sh -b -p $HOME/miniconda3
rm ${MINICONDA_VERSION}.sh
popd
echo 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
