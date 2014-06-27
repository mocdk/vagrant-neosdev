class profile::mongo {

	apt::key { 'mongo-10gen':
		key => '7F0CEB10',
		key_server => "keyserver.ubuntu.com"
	}


	apt::source { 'mongo':
		location => 'http://downloads-distro.mongodb.org/repo/debian-sysvinit',
		repos => "10gen",
		require => Apt::Key['mongo-10gen'],
		include_src => false,
		release => "dist"
	}


	package { 'mongo-server':
		name => 'mongodb-10gen',
		ensure => installed,
		require => Apt::Source['mongo']
	}

	service {'mongodb':
		ensure => 'running',
		require => Package['mongo-server'],
		enable => true
	}

	package {"php5-mongo":
		ensure => "present",
		require => Class['profile::php']
	}

}