Vagrant.configure("2") do |config|
  config.vm.box = "boxcutter/ubuntu1404-docker"
  config.vm.provision "shell", path: "install.consul.sh", privileged: false

  config.vm.define "consul-server" do |cs|
    cs.vm.hostname = "consul-server"
    cs.vm.network "private_network", ip: "172.20.20.31"
  end

  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "172.20.20.11"
  end

  (1..3).each do |i|
    config.vm.define "web#{i}" do |web|
      web.vm.hostname = "web#{i}"
      web.vm.network "private_network", ip: "172.20.20.2#{i}"
    end
  end

end
