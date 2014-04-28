MOC TYPO3 Neos demo-site Vagrant manifest
=========================================

Vagrant configuration for running a new debian based TYPO3 Neos dev or demo site for on an environment similar to
MOC A/S hosting production machines. The machines are running Debian wheezy, and are provisioned using the built-in puppet provisioner.

When installed, all required Neos packages are installed, and a basic TYPO3.org demo Neos site is set up with all requirements.

The vagrant files work equally well on Virtualbox or VMWare fusion. The later has significant better performance though.

Installation
------------

Install the required debian basebox into your vagrant installation (only needed once).

Do a vagrant up and go check out that new Vibemme coffemachine at work, because you are in for little wait.

When properly caffeinated, your new neossite is available at http://192.168.66.50/ and you can log in at http://192.168.66.50/neos with username neosadmin and with password neosadmin

If you have problems with initiating local network when calling vagrant up, comment out the line

::

 config.vm.network :private_network, ip: "192.168.66.50"

In Vagrantfile and access the site on whatever IP is assigned to it via DHCP.


Virtualbox basebox installation
-------------------------------

Make sure you have a correct Debian box in vagrant. For vagrant with virtualbox, you could use the ones listed
here http://puppet-vagrant-boxes.puppetlabs.com/.

::

 vagrant box add debian http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box

VMWare fusion basebox installation
----------------------------------

Buy and install VMWare fusion.

Also buy the vagrant VMWare fusion adaptor. Follow the instruction which includes fetching
the plugin and installing the license with

::

 vagrant plugin install vagrant-vmware-fusion
 vagrant plugin license vagrant-vmware-fusion license.lic

Then import the correct debian box with

::

 vagrant box add debian http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vf503.box --provider vmware_fusion

All of theses steps are only needed on the first run.

When using vmware_fusion, remember to set the env variable VAGRANT_DEFAULT_PROVIDER=vmware_fusion or specify
--provider=vmware_fusion when doing vagrant up

::

 vagrant up --provider=vmware_fusion

Enjoy!
