class profile::rabbitmq-server {
	# Include rabbit server
	package {rabbitmq-server: ensure => present}
	service {rabbitmq-server:
		ensure => running,
		require => Package['rabbitmq-server']
	}
}