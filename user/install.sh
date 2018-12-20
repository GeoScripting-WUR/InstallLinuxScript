#!/bin/bash
# Script to install user-specific tools (i.e. conda)
bash install-conda.sh

# Make a conda environment with all needed tools
conda create -y --name geoscripting python=3.6 spyder pip jupyter seaborn "poppler<0.62"
source activate geoscripting
conda install -y --channel conda-forge folium matplotlib geopy osmnx rasterio geopandas rasterstats owslib pysal descartes twython

# Install IRKernel for Jupyter
echo 'install.packages("IRkernel", repos="https://cloud.r-project.org"); IRkernel::installspec()' | R --vanilla
