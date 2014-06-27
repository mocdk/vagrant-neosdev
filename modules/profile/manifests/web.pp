class profile::web {
	#Install Apache
	class { 'apache':
		mpm_module => 'prefork',
		default_vhost => false,
		purge_configs => false #We need to allow custom sites not controlled by puppet
	}

	apache::vhost { 'default.dev':
	  port    => 8081,
	  docroot => '/var/www/',
	  default_vhost => true,
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
		gid => 'www-data',
		groups => ['www-data', 'cdrom', 'sudo', 'audio', 'video'],
		require => Package['httpd']
	}


}