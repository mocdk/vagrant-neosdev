MOC TYPO3 Neos demo-site Vagrant manifest
=========================================

Vagrant configuration for running a new debian based TYPO3 Neos dev or demo site for an environment similar to
MOC hosting production machines. The machine runs Debian wheezy, and is provisioned using the built-in puppet provisioner.

Vagrant 1.5 or newer is requied

When installed, all required Neos packages are installed, and a basic TYPO3.org demo Neos site is set up with all requirements.

The vagrant files work equally well on Virtualbox or VMWare fusion. The latter has significant better performance though.

When the box is provisioned, an NFS export from the guest /home/sites/ is made available. You can mount this in your host
 with

::

 sudo mount -orw -oresvport  -t nfs 192.168.66.50:/home/sites workdir

Or use the provided mountNfs.sh script which will create a directory "workdir" and mount the guest /home/sites/

Installation
------------

Boxes for this are hosted on vagrantcloud, so there is no need to install any baseboxes.

Do a vagrant up and go and check out that new Vibemme coffeemachine at work, because you are in for little wait.

When properly caffeinated, your new Neos site is available at http://192.168.66.50/ and you can log in at http://192.168.66.50/neos with username neosadmin and password neosadmin

If you have problems with initiating local network when calling vagrant up, comment out the line

::

 config.vm.network :private_network, ip: "192.168.66.50"

in Vagrantfile and access the site on whatever IP is assigned to it via DHCP.


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

Note that we have to add the ssh key for our private repository git.moc.net to make it work. A convenient puppet module for this is present.

::

 class profile::myowncustomsite {
 	include profile::web
	include profile::php
	include profile::devtools
	include profile::db

	# Add private repository to roots known hosts
	ssh::known_hosts {'git.moc.net':
		username => 'root',
		homedir => '/root/'
	}

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
* Setup Virtualhost with same site in production mode
