#!/bin/sh
bash ./install-common.sh
ansible-playbook -K --connection=local -i 127.0.0.1, geoscripting-gui.yml
