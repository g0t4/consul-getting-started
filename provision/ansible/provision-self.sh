#!/usr/bin/env bash

cd /vagrant/provision/ansible

consul maint -enable

# Now each host can be bootstrapped with ansible, and update itself!
ansible-playbook site.yml

consul maint -disable
