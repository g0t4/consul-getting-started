Vagrant.configure("2") do |config|
  config.vm.box = "wesmcclure/ubuntu1404-docker"
  config.vm.provision "shell", path: "install.consul.sh", privileged: false

  ['sfo', 'nyc'].each do |dc|

    ip_prefix = dc == 'sfo' ? '172.20.20.1' : '172.20.20.'

    (1..3).each do |i|
      config.vm.define "#{dc}-consul-server#{i}" do |cs|
        cs.vm.hostname = "#{dc}-consul-server#{i}"
        cs.vm.network "private_network", ip: "#{ip_prefix}3#{i}"
        cs.vm.provision "shell", path: "provision/setup.consul-server.sh", privileged: false
      end
    end

    config.vm.define "#{dc}-lb" do |lb|
      lb.vm.hostname = "#{dc}-lb"
      lb.vm.network "private_network", ip: "#{ip_prefix}11"
      lb.vm.provision "shell", path: "provision/install.consul-template.sh", privileged: false
      lb.vm.provision "shell", path: "provision/setup.lb.sh", privileged: false
    end

    (1..3).each do |i|
      config.vm.define "#{dc}-web#{i}" do |web|
        web.vm.hostname = "#{dc}-web#{i}"
        web.vm.network "private_network", ip: "#{ip_prefix}2#{i}"
        web.vm.provision "shell", path: "provision/install.ansible.sh", privileged: false
        web.vm.provision "shell", path: "provision/ansible/provision-self.sh", privileged: false
      end
    end


  end

end
