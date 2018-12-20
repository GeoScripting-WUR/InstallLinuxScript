#!/bin/sh
# Set up directories needed for nbgrader
# User needs to install nbgrader from conda-forge channel via conda
sudo mkdir -p /srv/nbgrader/exchange
sudo chmod ugo+rw /srv/nbgrader/exchange
sudo mkdir -p /etc/jupyter
echo 'c = get_config()' | sudo tee -a /etc/jupyter/nbgrader_config.py
echo 'c.Exchange.course_id = "geoscripting"' | sudo tee -a /etc/jupyter/nbgrader_config.py
