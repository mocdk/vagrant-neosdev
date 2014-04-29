class profile::java {

	package { 'java':
		name => 'default-jre-headless',
		ensure => 'installed'
	}

}