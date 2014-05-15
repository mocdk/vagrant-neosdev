# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "fvm"
  config.vm.box = "mocdk/debian-puppet-typo3"

  config.vm.network :private_network, ip: "192.168.66.60"
  config.vm.network "public_network"
  config.ssh.forward_agent = true
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end

  config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
  end
  config.vm.provider "vmware_fusion" do |v|
    v.memory = 1024
    v.cpus = 2
    v.gui = false
  end
end