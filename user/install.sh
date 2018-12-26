#!/bin/bash
# Script to install user-specific tools (i.e. conda)
bash install-conda.sh
export PATH="$HOME/miniconda3/bin:$PATH"

# Make a conda environment with all needed tools
conda create -y --name geoscripting python=3.6 spyder pip jupyter seaborn "poppler<0.62"
source activate geoscripting
conda install -y --channel conda-forge folium matplotlib geopy osmnx rasterio geopandas rasterstats owslib pysal descartes \
  twython nbgrader

# Install IRKernel for Jupyter
echo 'UserLib=Sys.getenv("R_LIBS_USER"); dir.create(UserLib, recursive=TRUE); install.packages("IRkernel", lib=UserLib, repos="https://cloud.r-project.org"); IRkernel::installspec()' | R --vanilla

# Activate nbgrader
jupyter nbextension install --sys-prefix --py nbgrader --overwrite
jupyter nbextension enable --sys-prefix --py nbgrader
jupyter serverextension enable --sys-prefix --py nbgrader
