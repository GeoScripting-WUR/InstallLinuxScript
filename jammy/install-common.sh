#!/bin/bash
sudo apt install -y ansible
#ansible-galaxy collection install community.general community.postgresql
ansible-playbook -K --connection=local -i 127.0.0.1, ansible-galaxy.yml
ansible-playbook -K --connection=local -i 127.0.0.1, geoscripting.yml
