MOC TYPO3 Neos vagrant file
==============================

Description
--------------

Simple Vagrant configuration for running a new debian based TYPO3 Neos dev or demo site

When installed, all required Neos packages are installed, and a basic Neos site is set up.

The vagrant files work equally well on Virtualbox or VMWare fusion. The later has significant better performance though.

Installation
------------

Install the required debian basebox into your vagrant installation (only needed once). Do a vagrant up and go check
out that new Vibemme coffemachine at work, because you are in for little wait. When properly caffeinated, your new
neossite is available at http://192.168.66.50/ and you can log in at user neossite with password neossite


Virtualbox basebox installation
-------------------------------

Make sure you have a correct Debian box in vagrant. For vagrant with virtualbox, you could use the ones listed
here http://puppet-vagrant-boxes.puppetlabs.com/.

 vagrant box add debian http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box

VMWare fusion basebox installation
----------------------------------

Buy and install VMWare fusion. Also buy the vagrant VMWare fusion adaptor. Follow the instruction which includes fetching
the plugin and installing the license with

 vagrant plugin install vagrant-vmware-fusion
 vagrant plugin license vagrant-vmware-fusion license.lic

Then import the correct debian box with

 http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vf503.box

All of theses steps are only needed on the first run.

Enjoy!
