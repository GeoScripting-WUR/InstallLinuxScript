#!/bin/sh
# Set up directories needed for nbgrader
# User needs to install nbgrader from conda-forge channel via conda
sudo mkdir -p /srv/nbgrader/exchange
sudo chmod ugo+rw /srv/nbgrader/exchange
sudo mkdir -p /etc/jupyter
sudo echo 'c = get_config()' >> /etc/jupyter/nbgrader_config.py
sudo echo 'c.Exchange.course_id = "geoscripting"' >> /etc/jupyter/nbgrader_config.py
