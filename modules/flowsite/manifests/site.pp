# == Class: php::apt
#
# Using composer, create a new website given a base-distribution
#
# === Parameters
#
# No parameters
#
# === Variables
#
# [*sitename*]
#   The name of the sites.
#   The site will be created inside the /home/sites/$sitename folder
#
# [*basedistribution*]
#   Compaster project to use for base distribution
#   Defaults to typo3/flow-base-distribution
#
# [*repository*]
#   Packagist repostory to use
#   Defaults to http://packagist.org/
#
# [*url*]
#   Url of the resulting website
#
# === Examples
#
#  include php::apt
#
# === Authors
#
# Jan-Erik Revsbech <janerik@moc.net>
#
# === Copyright
#
# Copyright 2012-2013 Jan-Erik Revsbech MOC A/S, unless otherwise noted.
#
define flowsite::site (
	$sitename = $title,
	$basedistribution='typo3/flow-base-distribution',
	$repository = 'http://packagist.org/',
	$url = $title,
	$port = 80) {

	## Create dir for the neos site
	file { "/home/sites/${sitename}": ensure => "directory", require => File["/home/sites"], owner => 'vagrant'}

	# Make logs directory
	file { "/home/sites/${sitename}/logs": ensure => "directory", require => File["/home/sites/${sitename}"], owner => 'vagrant'}

	# Install Neos base
	exec { "composer-install-${sitename}":
		environment => ["HOME=/home/sites/${sitename}"],
		command => "/usr/local/bin/composer create-project ${basedistribution} flow --dev -s'dev' --keep-vcs -n --repository-url='${repository}'",
		path    => '/usr/bin:/bin:/usr/sbin:/sbin',
		cwd     => "/home/sites/${sitename}",
		user    => 'vagrant',
		require => [Exec['download composer'], File["/home/sites/${sitename}"]],
		creates => "/home/sites/${sitename}/flow",
		timeout => 3600,
		notify  => Class['Apache::Service']
	}

	exec { "fix-permissions-${sitename}":
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		cwd     => "/home/sites/${sitename}/flow",
		user    => 'root',
		command => "php /home/sites/${sitename}/flow/flow flow:core:setfilepermissions vagrant www-data www-data",
		require => Exec["composer-install-${sitename}"],
		refreshonly => true
	}

	$dbHost = 'localhost'
	$dbName = $sitename
	$dbPassword = 'Haebahw0meVo'
	$dbUsername = $sitename

	file {"/home/sites/${sitename}/flow/Configuration/Settings.yaml":
		#content => $settings,
		content => template('flowsite/Settings.yaml.erb'),
		owner => 'vagrant',
		group => 'www-data',
		require => Exec["composer-install-${sitename}"]
	}

	apache::vhost { $url:
		port    => $port,
		#default_vhost => true,
		docroot => "/home/sites/${sitename}/flow/Web",
		docroot_owner => 'vagrant',
		docroot_group => 'www-data',
		access_log_file => 'access.log',
		error_log_file => 'error.log',
		logroot => "/home/sites/${sitename}/logs",
		require => Exec["composer-install-${sitename}"],
		directories => [{
			path => "/home/sites/${sitename}/flow/Web",
			allow_override => ['All'],
		}]

	}

	mysql::db { $sitename:
		user     => $sitename,
		password => $dbPassword,
		host     => 'localhost',
		grant    => ['all'],
		charset  => 'utf8',
		collate  => 'utf8_danish_ci'
	}

	#Run Doctrine migrate to populate the database
	exec {"doctrine-migrate-${sitename}":
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		cwd     => "/home/sites/${sitename}/flow",
		command => "php flow doctrine:migrate",
		user => "vagrant",
		require => [File["/home/sites/${sitename}/flow/Configuration/Settings.yaml"], Mysql::Db[$sitename], Exec["composer-install-${sitename}"]],
		onlyif => "php flow doctrine:migrationstatus | grep 'not migrated'"
	}

	#Todo: clear cache force

}