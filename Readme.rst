MOC TYPO3 Neos demo-site Vagrant manifest
=========================================

Vagrant configuration for running a new debian based TYPO3 Neos dev or demo site for an environment similar to
MOC hosting production machines. The machine runs Debian wheezy, and is provisioned using the built-in puppet provisioner.

When installed, all required Neos packages are installed, and a basic TYPO3.org demo Neos site is set up with all requirements.

The vagrant files work equally well on Virtualbox or VMWare fusion. The latter has significant better performance though.

Installation
------------

Install the required debian basebox into your vagrant installation (only needed once).

Do a vagrant up and go and check out that new Vibemme coffeemachine at work, because you are in for little wait.

When properly caffeinated, your new Neos site is available at http://192.168.66.50/ and you can log in at http://192.168.66.50/neos with username neosadmin and password neosadmin

If you have problems with initiating local network when calling vagrant up, comment out the line

::

 config.vm.network :private_network, ip: "192.168.66.50"

in Vagrantfile and access the site on whatever IP is assigned to it via DHCP.


Virtualbox basebox installation
-------------------------------

Make sure you have a correct debian box in vagrant. For vagrant with virtualbox, you could use the ones listed
here http://puppet-vagrant-boxes.puppetlabs.com/.

::

 vagrant box add debian http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box

VMWare fusion basebox installation
----------------------------------

Buy and install VMWare fusion.

Also buy the vagrant VMWare fusion adaptor. Follow the instructions which includes fetching
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

Modifying the manifest
----------------------

The manifest includes different puppet modules for installing Flow and Neos sites packages directly when provisioning the
machine.

Here are examples of different configurations that will install Flow or Neos sites

Install basic Flow site via composer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The site will be placed in /home/sites/myflowsite/ with a subfolder for flow, and one for apache logs. A singe Apache
Virtual host pointing to /home/sites/myflowsite/flow/Web is configured, and a database is created and Settings.yaml is
updated to connect to that database. Last the required doctrine:create commands are run.

::

 class profile::flowsite {
	include profile::web
	include profile::php
	include profile::devtools
	include profile::db

	flowsite::site {'myflowsite':
		require => Class['profile::devtools'],
		url => 'myflowsite.dev'
	}
 }

Install basic Neos site from your own composer repository, and import the site
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install a full Neos site from your own (in this case private) composer repository, create a user, and import a full site into
the new installation.

::

 class profile::myowncustomsite {
 	include profile::web
	include profile::php
	include profile::devtools
	include profile::db

	flowsite::site {'myneossite':
		package => "moc/mocnet-base-distribution",
		repository => 'https://packages.moc.net/'
		require => Class['profile::devtools'],
		url => 'myneossite.dev'
	}

	flowsite::neos::create-user {'neosadmin':
		username => 'neosadmin',
		password => 'MySecretPassword',
		firstname => 'MOC',
		lastname => 'Editor',
		role => 'Administrator',
		sitename => 'myneossite',
		require => Flowsite::Site['myneossite']
	}

	flowsite::neos::import-site {'Moc.Net':
		sitename => 'myneossite',
		package => 'Moc.Net',
		require => Flowsite::Site['myneossite']
	}
 }

Wish list and ToDo
------------------

* Make folder for sites configurable instead of being hardcoded to /home/sites
* Provide options for using FastCGI with Apache or Nginx instead
* Provide Varnish default settings
* Provide Elasticsearch setup
* Setup Virtualhost with same site in production mode
* Cleaner dependencies
