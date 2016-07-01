## Setup

- Clone this repository locally
- Tested with Vagrant 1.8.4 and Consul 0.6.4
- Glossary: https://gist.github.com/g0t4/10c82f7ffd8a3f0cbd3980593259b7a8

### Mac

See [SETUP_MAC.sh](SETUP_MAC.sh)

### Windows Users

See [SETUP_WINDOWS.ps1](SETUP_WINDOWS.ps1)

- This repo forces LF line endings on checkout, see `.gitattributes`  
- If you want to edit files, install an http://editorconfig.org/#download plugin for whatever IDE you use to edit code.
    - This will ensure that files you create/modify have *nix LF endings and not CRLF. 
    - Otherwise, you'll have random trouble with scripts you create and try to run on *nix VMs.
    - I have already added a `.editorconfig` file to this project  

## Usage

There's a Vagrantfile in this repository that spins up the simulated environment.

If you want to run everything, there's 14 VMs in total, you need:
- 10 GB of free memory
- 4+ core CPU
- 20 GB of free disk space

If you have less than this, scale back the number of VMs you spin up, in the Vagrantfile, change the range `(1..3)` to `(1..2)` or `(1..1)`. If you update the consul-server count, update provision/cs-consul.d/server.json and set bootstrap_expect accordingly.

## Commands to use to launch services before we switch to upstart jobs:

### consul-server node
```
# vagrant ssh consul-server

consul agent -dev -advertise 172.20.20.31 -client 0.0.0.0 &
```

### web nodes

```
# vagrant ssh webX

ip=$(ifconfig eth1 | grep 'inet addr' | awk '{ print substr($2,6) }')
consul agent -advertise $ip -config-file /vagrant/common.json -config-file /vagrant/web.service.json &
/vagrant/provision/setup.web.sh
```

### lb node

```
# vagrant ssh lb 

/vagrant/provision/setup.lb.sh
/vagrant/provision/install.consul-template.sh

ip=$(ifconfig eth1 | grep 'inet addr' | awk '{ print substr($2,6) }')
consul agent -advertise $ip -config-file /vagrant/common.json -config-file /vagrant/lb.service.json &

consul-template -config /vagrant/provision/lb.consul-template.hcl &

# Install config into KV store for lb
curl -X PUT -d '4096' http://localhost:8500/v1/kv/prod/portal/haproxy/maxconn
curl -X PUT -d '5s' http://localhost:8500/v1/kv/prod/portal/haproxy/timeout-connect
curl -X PUT -d '50s' http://localhost:8500/v1/kv/prod/portal/haproxy/timeout-server
curl -X PUT -d '50s' http://localhost:8500/v1/kv/prod/portal/haproxy/timeout-client
curl -X PUT -d 'enable' http://localhost:8500/v1/kv/prod/portal/haproxy/stats
```