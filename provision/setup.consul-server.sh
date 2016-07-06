#!/usr/bin/env bash

# copy config file for consul
sudo cp /vagrant/provision/cs-consul.d/* /etc/consul.d

# start the service
sudo service consul start

# sleep a while to allow for leader election once last node is up to insert below keys
sleep 5s

# Install config into KV store for lb
curl -X PUT -d '4096' http://localhost:8500/v1/kv/prod/portal/haproxy/maxconn
curl -X PUT -d '5s' http://localhost:8500/v1/kv/prod/portal/haproxy/timeout-connect
curl -X PUT -d '50s' http://localhost:8500/v1/kv/prod/portal/haproxy/timeout-server
curl -X PUT -d '50s' http://localhost:8500/v1/kv/prod/portal/haproxy/timeout-client
curl -X PUT -d 'enable' http://localhost:8500/v1/kv/prod/portal/haproxy/stats