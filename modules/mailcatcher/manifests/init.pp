class mailcatcher {

	package {'build-essential':
		ensure => present
	}

	package { 'sqlite3':
		ensure => present
	}

	package { 'libsqlite3-dev':
		ensure => present
	}

	package { 'mailcatcher':
		provider => gem,
		ensure => present,
		require => Package['sqlite3', 'libsqlite3-dev']
	}


	file { '/etc/init.d/mailcatcher':
		content => template('mailcatcher/service.sh.erb'),
		alias => 'mailcatcher',
		mode => 0755
	}

	service { 'mailcatcher':
		ensure   => running,
	}



}
