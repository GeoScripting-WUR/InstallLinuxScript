#!/bin/bash

# Set up snapper to do snapshots of both root and /home
sudo snapper -c root create-config /
sudo snapper -c home create-config /home
