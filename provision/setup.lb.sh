#!/usr/bin/env bash

# Copy haproxy consul-template template
cp /vagrant/provision/haproxy.ctmpl /home/vagrant/.

# Create haproxy.cfg config file, this must exist before the docker container starts
# Otherwise, the docker engine will create a directory in its place
# When consul-template fires for the first time it will update the contents of this file
touch /home/vagrant/haproxy.cfg

# Run haproxy in a docker container
# Mount the haproxy config file
docker run -d \
           --name haproxy \
           -p 80:80 \
           --restart unless-stopped \
           -v /home/vagrant/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
           haproxy:1.6.5-alpine

# Copy consul configs and start consul
sudo cp /vagrant/provision/lb-consul.d/* /etc/consul.d
sudo service consul start

# Copy consul-template configs and start consul-template
sudo cp /vagrant/provision/lb-consul-template.d/* /etc/consul-template.d
sudo service consul-template start
