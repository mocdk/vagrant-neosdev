MOC TYPO3 Neos vagrant file
==============================

Description
--------------

Simple Vagrant configuration for running a new debian based TYPO3 Neos dev or demo site

When installed, all required Neos packages are installed, and a basic Neos site is set up.

Installation
---------------

Make sure you have a correct Debian box in vagrant. For vagrant with virtualbox, you could use the ones listeded here http://puppet-vagrant-boxes.puppetlabs.com/

 vagrant box add debian http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box

After this, just rung

 vagrant up

Wait for 10-20 minutes depending on internet speed, and then access

 http://192.168.33.50/setup/

To set up your Neos installation.

Enjoy!
