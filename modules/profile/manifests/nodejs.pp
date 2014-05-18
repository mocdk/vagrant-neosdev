class profile::nodejs {

	package { 'nodejs':
		ensure => present,
		require => Apt::Source['backports']
	}

}