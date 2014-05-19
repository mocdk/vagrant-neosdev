Venstre.dk Vagrant environment
==============================


This vagrant environment is used for development of the Venstre.dk Neos site. 

To get started, simply run vagrant up to have a full working installation.

The machine will contain an Apache webserver on port 8081 and Varnish listening on port 80. 
It will also include memcached and elasticsearch for your conveniance.

To edit files, run the script mountNfs.sh which will mount /home/sites into a folder workdir. 
All files will be written with user vagrant and group www-data.

You can ssh into the machine with vagrant ssh

The site is located in /home/sites/venstre.dk/flow/

Remember to do 

git config --global user.name "YOURNAME"
git config --global user.email "YOUR EMAIL"

Before you do any git commiting.

Enjoy!
