# Open a powershell prompt with admin privileges
# Install chocolatey https://chocolatey.org/
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

choco install vagrant
choco install consul

# Install cygwin via cyg-get, see below
# OR, use Git BASH for ssh or install ssh in your PATH
choco install cyg-get

# Close powershell prompt and open a new one
cyg-get openssh bash-completion wget

# Open cygwin, then:

# Install bash completion for vagrant
# https://github.com/kura/vagrant-bash-completion
wget https://raw.github.com/kura/vagrant-bash-completion/master/etc/bash_completion.d/vagrant \
    -O /etc/bash_completion.d/vagrant

# Install consul bash completion, note that this is built for Consul v0.4:
# https://github.com/nzroller/consul-bash-completion
wget https://raw.githubusercontent.com/nzroller/consul-bash-completion/master/consul \
    -O `brew --prefix`/etc/bash_completion.d/consul

# Close and reopen cygwin, use verify steps from Mac recommendations above
