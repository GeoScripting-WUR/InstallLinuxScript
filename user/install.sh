#!/bin/bash
# Script to install user-specific tools (i.e. conda)
bash install-conda.sh
export PATH="$HOME/miniconda3/bin:$PATH"

# Make a conda environment with all needed tools
conda create -y --name geoscripting python=3.6 spyder pip jupyter seaborn owslib "poppler<0.62"
source activate geoscripting
conda install -y --channel conda-forge folium matplotlib geopy osmnx rasterio geopandas rasterstats pysal descartes \
  twython nbgrader
# Fix breakage from https://github.com/conda-forge/rasterio-feedstock/issues/98
conda install -y --channel conda-forge --override-channels "gdal>2.2.4"
conda install kealib=1.4.7 -y

# Install IRKernel for Jupyter
echo 'UserLib=Sys.getenv("R_LIBS_USER"); dir.create(UserLib, recursive=TRUE); install.packages("IRkernel", lib=UserLib, repos="https://cloud.r-project.org"); library(IRkernel, lib=UserLib); IRkernel::installspec()' | R --vanilla

# Activate nbgrader
jupyter nbextension install --sys-prefix --py nbgrader --overwrite
jupyter nbextension enable --sys-prefix --py nbgrader
jupyter serverextension enable --sys-prefix --py nbgrader
