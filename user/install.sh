#!/bin/sh
# Script to install user-specific tools (i.e. conda)
sh install-conda.sh

# Make a conda environment with all needed tools
conda create --name geoscripting python=3.6 geopandas spyder owslib pip jupyter
conda activate geoscripting
conda install --channel conda-forge folium matplotlib geopy osmnx rasterio geopandas rasterstats owslib pysal descartes
