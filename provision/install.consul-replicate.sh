#!/usr/bin/env bash

# Download consul-replicate
CONSUL_REPLICATE_VERSION=0.2.0
URL=https://releases.hashicorp.com/consul-replicate/${CONSUL_REPLICATE_VERSION}/consul-replicate_${CONSUL_REPLICATE_VERSION}_linux_amd64.zip
curl $URL -o consul-replicate.zip

# Install consul-replicate
unzip consul-replicate.zip
sudo chmod +x consul-replicate
sudo mv consul-replicate /usr/bin/consul-replicate

# Example usage:
# consul-replicate -prefix "global@nyc"
