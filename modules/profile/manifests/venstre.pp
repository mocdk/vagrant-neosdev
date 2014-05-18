class profile::venstre {
	include profile::web
	include profile::php
	include profile::devtools
	include profile::db
	include profile::memcached
	include profile::elasticsearch
	include profile::varnish
	include profile::nfs-server
	include nodejs::moc

	package {'pngcrush': ensure => installed}

	$npm_packages = ['grunt','grunt-cli']
	package { $npm_packages:
		ensure  => present,
		provider => 'npm',
		require => Package['npm']
	}

	class { 'apt::backports':
	}

	$sitename = 'venstre.dk'

	flowsite::site {$sitename:
		require => Class['profile::devtools'],
		basedistribution => 'venstre/venstredk-base-distribution',
		url => 'venstre.dev',
		repository => "http://packages.moc.net/",
		port => 8081
	}

	flowsite::neos::create-user {'neosadmin':
		username => 'neosadmin',
		password => 'neosadmin',
		firstname => 'MOC',
		lastname => 'Editor',
		role => 'Administrator',
		sitename => $sitename,
		require => Flowsite::Site[$sitename]
	}

	flowsite::neos::import-site {'Venstre.VenstreDk':
		sitename => $sitename,
		package => 'Venstre.VenstreDk',
		require => Flowsite::Site[$sitename]
	}

	exec {'npm-install-venstredk':
		command => 'npm install',
		path => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		cwd => "/home/sites/${sitename}/flow/Packages/Sites/Venstre.VenstreDk/Build/Grunt/",
		user => 'vagrant',
		require => [Package['npm'], Flowsite::Neos::Import-site['Venstre.VenstreDk'], Package['pngcrush']]
	}

}