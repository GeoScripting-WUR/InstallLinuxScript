#!/bin/bash
# Install script for servers
bash ./install-vm.sh
ansible-playbook -K --connection=local -i 127.0.0.1, server.yml
