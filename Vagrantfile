Vagrant.configure("2") do |config|
  config.vm.box = "boxcutter/ubuntu1404-docker"
  config.vm.provision "shell", path: "install.consul.sh", privileged: false
  config.vm.provision "shell", path: "provision/install.nomad.sh", privileged: false

  ['sfo', 'nyc'].each do |dc|

    ip_prefix = dc == 'sfo' ? '172.20.20.1' : '172.20.20.'

    (1..3).each do |i|
      config.vm.define "#{dc}-consul-server#{i}" do |cs|
        cs.vm.hostname = "#{dc}-consul-server#{i}"
        cs.vm.network "private_network", ip: "#{ip_prefix}3#{i}"
        cs.vm.provision "shell", path: "provision/setup.consul-server.sh", privileged: false
      end
    end

    (1..4).each do |i|
      config.vm.define "#{dc}-worker#{i}" do |worker|
        worker.vm.hostname = "#{dc}-worker#{i}"
        worker.vm.network "private_network", ip: "#{ip_prefix}2#{i}"
        worker.vm.provision "shell", path: "provision/setup.worker.sh", privileged: false
      end
    end


  end

end
