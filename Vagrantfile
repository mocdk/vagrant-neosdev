# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "neos-dev"
  config.vm.box = "mocdk/debian-puppet-typo3"

  config.vm.network :private_network, ip: "192.168.66.80"
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

  # Check if ~/.gitconfig exists locally
  # If so, copy basic Git Config settings to Vagrant VM
  if File.exists?(File.join(Dir.home, ".gitconfig"))
      git_name = `git config user.name`   # find locally set git name
      git_email = `git config user.email` # find locally set git email
      # set git name for 'vagrant' user on VM
      config.vm.provision :shell, :inline => "echo 'Saving local git username to VM...' && sudo -i -u vagrant git config --global user.name '#{git_name.chomp}'"
      # set git email for 'vagrant' user on VM
      config.vm.provision :shell, :inline => "echo 'Saving local git email to VM...' && sudo -i -u vagrant git config --global user.email '#{git_email.chomp}'"
    end

  if File.exists?("config/local-bootstrap.sh")
    config.vm.provision :shell, :inline => "echo '   > > > running config/local_bootstrap.sh'"
    config.vm.provision :shell, :path => "config/local-bootstrap.sh"
  end
end