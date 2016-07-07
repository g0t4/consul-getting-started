#!/usr/bin/env bash

# Download nomad
NOMAD_VERSION=0.4.0
curl https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip

# Install nomad
unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad

# Create config directory
sudo mkdir /etc/nomad.d
sudo chmod a+w /etc/nomad.d

# Install common nomad config
sudo cp /vagrant/provision/common-nomad.d/* /etc/nomad.d

# Install upstart job
sudo cp /vagrant/provision/upstart/nomad.conf /etc/init/.
