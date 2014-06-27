class profile::beanstalk {

	package {'beanstalk': name => 'beanstalkd', ensure => present}

	file {'/etc/default/beanstalkd':
		require => Package['beanstalk'],
		content => '
BEANSTALKD_LISTEN_ADDR=0.0.0.0
BEANSTALKD_LISTEN_PORT=11300
DAEMON_OPTS="-l $BEANSTALKD_LISTEN_ADDR -p $BEANSTALKD_LISTEN_PORT"
START=yes'
	}

	service {'beanstalkd': ensure => running, require => [File['/etc/default/beanstalkd'], Package['beanstalk']], enable => true}
}