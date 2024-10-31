#!/bin/bash

MINICONDA_VERSION="Miniforge-Linux-x86_64"
pushd /tmp
wget https://github.com/conda-forge/miniforge/releases/latest/download/${MINICONDA_VERSION}.sh
## Unattended install, will put into ~/mamba
bash ${MINICONDA_VERSION}.sh -b -p $HOME/mamba
rm ${MINICONDA_VERSION}.sh
popd
echo 'export PATH="$HOME/mamba/bin:$PATH"' >> ~/.bashrc
