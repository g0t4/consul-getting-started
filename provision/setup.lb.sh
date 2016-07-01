#!/usr/bin/env bash

cp /vagrant/provision/haproxy.cfg /home/vagrant/.

# Run haproxy in a docker container
# Mount the haproxy config file
docker run -d \
           --name haproxy \
           -p 80:80 \
           --restart unless-stopped \
           -v /home/vagrant/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
           haproxy:1.6.5-alpine

