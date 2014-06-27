class profile::neos-dev {
	include profile::web
	include profile::php
	include profile::devtools
	include profile::db
	include profile::memcached
	include profile::elasticsearch
	include profile::varnish
	include profile::nfs-server
	include nodejs::moc
	include profile::mongo
	include profile::beanstalk

	#Packages for doing advanved image manipulation and optimization
	$packageList = ['advancecomp', 'gifsicle', 'jhead', 'jpegoptim', 'libjpeg-progs', 'optipng', 'pngcrush']
	package {$packageList: ensure => installed}

	class { 'ohmyzsh': }
	ohmyzsh::install { 'vagrant': }
	ohmyzsh::theme { 'vagrant': theme => 'dpoggi' }
	ohmyzsh::plugins { 'vagrant': plugins => 'git github' }

	package { 'image_optim':
		ensure   => 'installed',
		provider => 'gem',
	}

	$npm_packages = ['grunt','grunt-cli', 'svgo']
	package { $npm_packages:
		ensure  => present,
		provider => 'npm',
		require => Package['npm']
	}

	class { 'apt::backports':
	}

	file { '/etc/motd':
		ensure  => file,
		backup  => false,
		content => template("profile/motd/motd.erb"),
	}

}