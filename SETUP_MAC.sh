#!/usr/bin/env bash

# Open a terminal
# Install Homebrew http://brew.sh/
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Use cask to install pre-built binaries
# https://caskroom.github.io/
brew tap caskroom/cask
brew cask install vagrant consul

# Install autocompletion, optional:
# https://github.com/Homebrew/homebrew-completions
brew install bash-completion
brew tap homebrew/completions
brew install vagrant-completion

# Install consul bash completion, note that this is built for Consul v0.4:
# https://github.com/nzroller/consul-bash-completion
brew install wget
wget https://raw.githubusercontent.com/nzroller/consul-bash-completion/master/consul \ 
    -O `brew --prefix`/etc/bash_completion.d/consul

# Add bash completion to bash profile
cat >> ~/.bash_profile <<<SCRIPT

if [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; then
    source `brew --prefix`/etc/bash_completion.d/vagrant
fi

SCRIPT

# Optional for parsing json via the CLI, because consul has many HTTP APIs that expose json
brew install jq

# CLOSE the terminal, open a new one

# Verify worked, I'm using vagrant 1.8.4 in this course and consul 0.6.4
vagrant -v
consul -v 

# Verify auto complete
# type: `vagrant ` and then hit tab, should see vagrant sub commands, not files. i.e. status, up, down