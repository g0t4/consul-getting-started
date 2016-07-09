#!/usr/bin/env bash
set -x
export NOMAD_ADDR=http://172.20.20.31:4646
nomad status

nomad plan /vagrant/jobs/web.hcl


nomad run /vagrant/jobs/web.hcl

exit
# split

sed -i 's/count\s*=\s*[0-9]*/count = 3/' /vagrant/jobs/web.hcl
nomad plan /vagrant/jobs/web.hcl

sed -i 's/nginx/nginx:1\.10-alpine/' /vagrant/jobs/web.hcl
nomad plan /vagrant/jobs/web.hcl

exit
# split

nomad run /vagrant/jobs/web.hcl


nomad status web
nomad alloc-status -stats 986784b2
nomad node-status -stats c947ddd7
