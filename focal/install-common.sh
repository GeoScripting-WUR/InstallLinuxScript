#!/bin/bash
sudo apt install -y ansible
ansible-galaxy collection install community.general
ansible-playbook -K --connection=local -i 127.0.0.1, geoscripting.yml
