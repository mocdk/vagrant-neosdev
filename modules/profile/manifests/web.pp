class profile::web {
	#Install Apache
	class { 'apache':
		mpm_module => 'prefork',
		default_vhost => false
	}

	# Make sure PHP is included
	include apache::mod::php

	apache::mod { 'rewrite': }
	apache::mod { 'headers': }


	# Root directory for sites in MOC Configuration
	file { "/home/sites":
		ensure => "directory",
		owner => 'vagrant',
		require => Package['httpd']
	}

	#Make sure the vagrant user is part of the www-data group
	user {'vagrant':
		ensure => present,
		groups => ['vagrant' , 'cdrom', 'sudo', 'audio', 'video', 'www-data'],
		require => Package['httpd']
	}


}