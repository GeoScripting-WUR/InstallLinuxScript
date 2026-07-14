#!/bin/sh
# Installer for VMWare Horizon VMs
bash ./install.sh
ansible-playbook -K --connection=local -i 127.0.0.1, vm.yml
