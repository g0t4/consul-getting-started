#!/usr/bin/env bash

# Old web server provisioning script, moved to Ansible

# Create an html page with the ip of this node
ip=$(ifconfig eth1 | grep 'inet addr' | awk '{ print substr($2,6) }')
echo "<h1>$ip $(hostname)</h1>" > /home/vagrant/ip.html

# Run nginx via docker
# mount the ip.html page as a volume in the root of the default nginx site
# thus we can access this page via `curl localhost:8080/ip.html`
docker run -d \
           --name web \
           -p 8080:80 \
           --restart unless-stopped \
           -v /home/vagrant/ip.html:/usr/share/nginx/html/ip.html:ro \
           nginx

# copy config file for consul
sudo cp /vagrant/provision/web-consul.d/* /etc/consul.d

# start the service
sudo service consul start