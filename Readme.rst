MOC TYPO3 Neos and Flow general purpose development server
===========================================================

Vagrant configuration for developing TYPO3 FLow and Neos site in an environment similar to
MOC hosting production machines. The machine runs Debian wheezy, and is provisioned using the built-in puppet provisioner.

Vagrant 1.5 or newer is required

No virtual hosts are created, so you can create them yourself, and vagrant provision will not overwrite them.

The vagrant files work equally well on Virtualbox or VMWare fusion. The latter has significant better performance though.

When the box is provisioned, an NFS export from the guest /home/sites/ is made available. You can mount this in your host
 with

::

 sudo mount -orw -oresvport  -t nfs 192.168.66.80:/home/sites workdir

Or use the provided mountNfs.sh script which will create a directory "workdir" and mount the guest /home/sites/

Since this is a general purpose server, it comes installed with the following cool things

 * Varnish listening on port 80
 * Apache listening on port 8081
 * ElasticSearch on default port
 * Beanstalk on default port
 * MongoDB on default port
 * Memcached on defailt port
 * MySQL on default port
 * Nodejs and npm and grunt, grunt-cli and svgo pre-installed globally
 * Compass (although we recommend running it with Grunt)
 * ZSh with theme dpoggi and the git and github plugins loaded
 * Git version 1.9 (from backports)


Installation
------------

Boxes for this are hosted on vagrantcloud, so there is no need to install any baseboxes.

Do a vagrant up and go and check out that new Vibemme coffeemachine at work, because you are in for little wait (2-5 minuttes on a decent network connection.

If you have problems with initiating local network when calling vagrant up, comment out the line

::

 config.vm.network :private_network, ip: "192.168.66.80"

in Vagrantfile and access the site on whatever IP is assigned to it via DHCP.

Vagrant will give a few warnings and errors that should be ignored: default: "stdin: is not a tty" and "Warning: Config file /etc/puppet/hiera.yaml not found, using Hiera defaults".

