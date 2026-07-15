#!/bin/bash
# Script to install user-specific tools (i.e. conda)
bash install-conda.sh
export PATH="$HOME/mamba/bin:$PATH"

## Make a conda environment with all needed tools

# Automatic way
#conda env create -f environment.yml
#source activate geoscripting
source activate base

mamba install -y jupyter

# Install IRKernel for Jupyter
echo 'UserLib=Sys.getenv("R_LIBS_USER"); dir.create(UserLib, recursive=TRUE); try(install.packages("IRkernel", lib=UserLib, repos="https://cloud.r-project.org")); library(IRkernel, lib=UserLib); IRkernel::installspec()' | R --vanilla

# Activate nbgrader
#jupyter nbextension install --sys-prefix --py nbgrader --overwrite
#jupyter nbextension enable --sys-prefix --py nbgrader
#jupyter serverextension enable --sys-prefix --py nbgrader
