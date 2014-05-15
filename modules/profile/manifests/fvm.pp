class profile::fvm {
	include profile::web
	include profile::php
	include profile::devtools
	include profile::db
	include profile::nfs-server
	include profile::mongo
	include profile::typo3solr
	include profile::beanstalk
	include profile::memcached
	include profile::varnish

	include supervisor

	class { 'apt::backports':
	}

	package {'wkhtmltopdf': ensure => installed }

	# Add private repository to roots known hosts
	ssh::known_hosts {'github.com': username => 'vagrant'}
	ssh::known_hosts {'git.moc.net': username => 'vagrant'}
	ssh::known_hosts {'fvmfile1': username => 'vagrant'}

	# Create neede folder structures
	file {'/home/sites/fvm.dk': ensure => directory, owner => "vagrant", group=>"www-data"}
	file {'/home/sites/fvm.dk/htdocs': ensure => directory, require => File['/home/sites/fvm.dk'], owner => "vagrant", group=>"www-data"}
	file {'/home/sites/fvm.dk/logs': ensure => directory, require => File['/home/sites/fvm.dk'], owner => "www-data"}

	# Kickstart fvm.dev apache virtualhost
	apache::vhost { 'fvm.dev':
		port    => '8081',
		default_vhost => true,
		docroot => "/home/sites/fvm.dk/htdocs",
		docroot_owner => 'vagrant',
		docroot_group => 'www-data',
		access_log_file => 'access.log',
		error_log_file => 'error.log',
		logroot => "/home/sites/fvm.dk/logs",
		require => File['/home/sites/fvm.dk/htdocs', '/home/sites/fvm.dk/logs'],
		directories => [{
			path => "/home/sites/fvm.dk/htdocs",
			allow_override => ['All'],
		}]
	}

	$dbHost = 'localhost'
	$dbName = 'fvm'
	$dbPassword = 'Iaebahw0meVo'
	$dbUsername = 'fvm'
	$sitePath = '/home/sites/fvm.dk/'

	mysql::db { $dbName:
		user     => $dbUsername,
		password => $dbPassword,
		host     => 'localhost',
		grant    => ['all'],
		charset  => 'utf8',
		collate  => 'utf8_danish_ci',
		require => Class['profile::db']
	}

	# Copy init-site script
	file {'/home/sites/fvm.dk/init-site.sh':
		#source  => 'puppet:///modules/profile/fvm/init-site.sh',
		content => template('profile/fvm/init-site.sh.erb'),
		require => File['/home/sites/fvm.dk'],
		owner => 'vagrant',
		mode => 0700
	}


	supervisor::command { 'fvmQueue':
		command => '/usr/bin/php /home/sites/fvm.dk/htdocs/typo3/cli_dispatch.phpsh extbase queueworker:start 50 true',
		user => 'www-data',
		stdout_logfile => '/home/sites/fvm.dk/logs/fvmQueue.log',
		stderr_logfile => '/home/sites/fvm.dk/logs/fvmQueue-error.log',
	}
}