#!/usr/bin/env bash

# Install ansible
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
# Using 2.1 at time of recording
