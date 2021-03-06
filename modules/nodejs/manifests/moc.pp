class nodejs::moc {

	# All this shananigans just to install npm..
	apt::source { 'sid':
		location    => 'http://ftp.us.debian.org/debian/',
		release     => 'sid',
		repos       => 'main',
		pin         => 100,
		include_src => false,
	}

	package { 'nodejs':
		ensure  => installed
	}

	exec { 'update-alternatives-nodejs':
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		command => 'update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100',
		unless => 'update-alternatives --list nodejs',
		require => Package['nodejs']
	}

	package { 'npm':
		ensure  => present,
		require => [Apt::Source['sid'], Package['nodejs']]
	}
}