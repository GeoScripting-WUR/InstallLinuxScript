#!/bin/bash
# Script to install user-specific tools (i.e. conda)
bash install-conda.sh
export PATH="$HOME/miniconda3/bin:$PATH"

# Make a conda environment with all needed tools
conda create -n geoscripting python=3 pip jupyter seaborn pyproj spyder rasterio geopandas kealib matplotlib owslib pysal descartes -y
source activate geoscripting
conda install -c conda-forge rasterstats folium geopy osmnx -y
pip install fiona==1.8.8

# Install IRKernel for Jupyter
echo 'UserLib=Sys.getenv("R_LIBS_USER"); dir.create(UserLib, recursive=TRUE); install.packages("IRkernel", lib=UserLib, repos="https://cloud.r-project.org"); library(IRkernel, lib=UserLib); IRkernel::installspec()' | R --vanilla

# Activate nbgrader
#jupyter nbextension install --sys-prefix --py nbgrader --overwrite
#jupyter nbextension enable --sys-prefix --py nbgrader
#jupyter serverextension enable --sys-prefix --py nbgrader
