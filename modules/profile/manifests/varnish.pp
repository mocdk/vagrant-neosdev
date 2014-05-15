class profile::varnish ($webserver_port = 8081, $varnish_port = 80) {

	package {'varnish': ensure => installed }

	service {'varnish': ensure => running }

	file { "/etc/varnish/default.vcl":
		content => template('profile/varnish/default.vcl.erb'),
		require => Package['varnish'],
		notify => Service['varnish']
	}

	file { "/etc/default/varnish":
		content => template('profile/varnish/varnish_defaults.erb'),
		require => Package['varnish'],
		notify => Service['varnish']
	}

}