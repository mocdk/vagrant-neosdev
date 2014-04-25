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
define flowsite::site ($sitename = $title, $basedistribution='typo3/flow-base-distribution', $repository = 'http://packagist.org/', $url = $title) {

	## Create dir for the neos site
	file { "/home/sites/${sitename}": ensure => "directory", require => File["/home/sites"], owner => 'vagrant'}

	# Make logs directory
	file { "/home/sites/${sitename}/logs": ensure => "directory", require => File["/home/sites/${sitename}"], owner => 'vagrant'}

	notify {"Installing site ${basedistribution} from repository ${repository}. Please wait, it might take a while....":}

	# Install Neos base
	exec { 'install-neos-base':
		environment => ["HOME=/home/sites/${sitename}"],
		command => "/usr/local/bin/composer create-project ${basedistribution} flow --dev -s'dev' --repository-url='${repository}'",
		path    => '/usr/bin:/bin:/usr/sbin:/sbin',
		cwd     => "/home/sites/${sitename}",
		user    => 'vagrant',
		require => [Exec['download composer'], File["/home/sites/${sitename}"]],
		creates => "/home/sites/${sitename}/flow",
		timeout => 1800,
		notify  => Class['Apache::Service'],
	}


	exec { 'fix-permissions':
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		cwd     => "/home/sites/${sitename}/flow",
		user    => 'root',
		command => "php /home/sites/${sitename}/flow/flow flow:core:setfilepermissions vagrant www-data www-data",
		require => Exec['install-neos-base']
	}

	apache::vhost { $url:
		port    => '80',
		#default_vhost => true,
		docroot => "/home/sites/${sitename}/flow/Web",
		docroot_owner => 'vagrant',
		docroot_group => 'www-data',
		access_log_file => 'access.log',
		error_log_file => 'error.log',
		logroot => "/home/sites/${sitename}/logs",
		require => Exec['fix-permissions', 'install-neos-base']
	}

	#todo rebuild cache

}