#!/usr/bin/env bash

# start the consul service
sudo service consul start

# Install client nomad config
sudo cp /vagrant/provision/client-nomad.d/* /etc/nomad.d

# start the nomad service
sudo service nomad start
