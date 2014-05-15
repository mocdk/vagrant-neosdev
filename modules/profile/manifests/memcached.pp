class profile::memcached {

	package {'memcached': ensure => installed }

	service {'memcached':
		ensure => running,
		require => Package['memcached']
	}
}