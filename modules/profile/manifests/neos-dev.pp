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

# Add private repository to roots known hosts
		ssh::known_hosts { 'github.com': username => 'vagrant' }
		ssh::known_hosts { 'git.moc.net': username => 'vagrant' }
		ssh::known_hosts { 'gerrit.moc.net': username => 'vagrant' }
		ssh::known_hosts { 'gerrit.mocsystems.com': username => 'vagrant' }
		ssh::known_hosts { 'moc-files': username => 'vagrant' }

#Packages for doing advanved image manipulation and optimization
		$packageList = ['advancecomp', 'gifsicle', 'jhead', 'jpegoptim', 'libjpeg-progs', 'optipng', 'pngcrush']
		package { $packageList: ensure => installed }

		class { 'ohmyzsh': }
		ohmyzsh::install { 'vagrant': }
		ohmyzsh::theme { 'vagrant': theme => 'dpoggi' }
		ohmyzsh::plugins { 'vagrant': plugins => 'git github' }

		file { '/home/vagrant/.zshrc':
				ensure  => file,
				backup  => false,
				content => template("profile/profile/.zshrc.erb"),
				require => Ohmyzsh::Install['vagrant']
		}

		file { '/home/vagrant/.gitconfig':
				ensure  => file,
				backup  => false,
				content => template("profile/profile/.gitconfig.erb"),
		}

		file { '/home/vagrant/.gitignore_global':
				ensure  => file,
				backup  => false,
				content => template("profile/profile/.gitignore_global.erb"),
		}

		package { 'image_optim':
				ensure   => 'installed',
				provider => 'gem',
		}

		$npm_packages = ['grunt','grunt-cli', 'svgo']
		package { $npm_packages:
				ensure   => present,
				provider => 'npm',
				require  => Package['npm']
		}

		class { 'apt::backports':
		}

		file { '/etc/motd':
				ensure  => file,
				backup  => false,
				content => template("profile/motd/motd.erb"),
		}

}