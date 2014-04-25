# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "mocflow"
  config.vm.box = "debian"
  config.vm.network :private_network, ip: "192.168.66.50"
  config.ssh.forward_agent = true
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end
  #config.vm.synced_folder "workdir", "/home/sites", type: "nfs"
  #config.vm.synced_folder "workdir", "/home/sites", owner: "vagrant", group: "www-data", mount_options: ["dmode=775,fmode=774"]
  config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
  end
  config.vm.provider "vmware_fusion" do |v|
    v.memory = 1024
    v.cpus = 2
    #v.gui = true
  end
end