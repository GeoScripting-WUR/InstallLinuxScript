#!/bin/sh
# Installs the default + r2u
bash ./install.sh
ansible-playbook -K --connection=local -i 127.0.0.1, r2u.yml
