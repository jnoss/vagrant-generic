# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/centos-6.5-64-puppet"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    vb.gui = true
  end

  config.vm.define "puppet" do |puppet|
    puppet.vm.network :private_network, ip: "192.168.11.3" #ext, can this be removed from this box?
    puppet.vm.network :private_network, ip: "192.168.22.3" #also ext, can be removed from this box?
    puppet.vm.network :private_network, ip: "172.16.33.3"
    puppet.vm.network :private_network, ip: "172.16.44.3"

    puppet.vm.hostname = "puppet"

    puppet.vm.provider :virtualbox do |virtualbox, override|
      virtualbox.customize ['modifyvm', :id, '--memory', '1024']
    end
  end

  config.vm.define "control" do |control|
    control.vm.network :private_network, ip: "192.168.11.4"
    control.vm.network :private_network, ip: "192.168.22.4"
    control.vm.network :private_network, ip: "172.16.33.4"
    control.vm.network :private_network, ip: "172.16.44.4"
    
    control.vm.network :forwarded_port, guest: 80,  host: 8000, auto_correct: true
    control.vm.network :forwarded_port, guest: 443, host: 8443, auto_correct: true
    control.vm.network :forwarded_port, guest: 8080,  host: 8080, auto_correct: true
    control.vm.network :forwarded_port, guest: 5000,  host: 8050, auto_correct: true
    
    control.vm.hostname = "control"

    control.vm.provider  :virtualbox do |virtualbox, override|
      virtualbox.customize ['modifyvm', :id, '--memory', '1024']
    end
  end

  config.vm.define "swiftstore1" do |swiftstore1|
    swiftstore1.vm.network :private_network, ip: "192.168.11.8"
    swiftstore1.vm.network :private_network, ip: "192.168.22.8"
    swiftstore1.vm.network :private_network, ip: "172.16.33.8"
    swiftstore1.vm.network :private_network, ip: "172.16.44.8"

    swiftstore1.vm.hostname = "swiftstore1"

    swiftstore1.vm.provider  :virtualbox do |virtualbox, override|
      virtualbox.customize ['modifyvm', :id, '--memory', '1024']
    end
  end

  config.vm.define "swiftstore2" do |swiftstore2|
    swiftstore2.vm.network :private_network, ip: "192.168.11.9"
    swiftstore2.vm.network :private_network, ip: "192.168.22.9"
    swiftstore2.vm.network :private_network, ip: "172.16.33.9"
    swiftstore2.vm.network :private_network, ip: "172.16.44.9"

    swiftstore2.vm.hostname = "swiftstore2"

    swiftstore2.vm.provider  :virtualbox do |virtualbox, override|
      virtualbox.customize ['modifyvm', :id, '--memory', '1024']
    end
  end

  config.vm.define "swiftstore3" do |swiftstore3|
    swiftstore3.vm.network :private_network, ip: "192.168.11.10"
    swiftstore3.vm.network :private_network, ip: "192.168.22.10"
    swiftstore3.vm.network :private_network, ip: "172.16.33.10"
    swiftstore3.vm.network :private_network, ip: "172.16.44.10"

    swiftstore3.vm.hostname = "swiftstore3"

    swiftstore3.vm.provider  :virtualbox do |virtualbox, override|
      virtualbox.customize ['modifyvm', :id, '--memory', '1024']
    end
  end

end
