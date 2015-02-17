class profile::devtools {


		$devBackportsPackagelist = [
				"git-man",
				"git"
		]

		apt::force { $devBackportsPackagelist:
				release => 'wheezy-backports',
				require => Apt::Source['backports'],
		}

		package { 'compass':
				ensure          => 'installed',
				provider        => 'gem',
				install_options => '--pre'
		}

		package { 'sass':
				ensure          => 'installed',
				provider        => 'gem',
				install_options => '--pre'
		}



/*
package { "PHPCS_TYPO3_SniffPool":
	provider => pear,
	ensure   => present,
	source   => "typo3/TYPO3SniffPool-alpha",
	require  => [
		Exec["pear-channel-pear.typo.org"],
		Package["php-pear"]
	]
}

package { "PHPCS_TYPO3v4_Standard":
	provider => pear,
	ensure   => present,
	source   => "typo3/TYPO3CMS-alpha",
	require  => Package[
		"PHPCS_TYPO3_SniffPool",
		"php-pear"
	]
}

exec { "pear-channel-pear.typo.org":
	command  => "/usr/bin/pear channel-discover pear.typo3.org",
	unless   => "/usr/bin/pear list-channels | grep -q typo3",
	require  => Package[
		"php-pear"
	]
}
*/


		exec { "pear update-channels" :
				command => "/usr/bin/pear update-channels",
				require => [Package['php-pear']]
		}

# install phpcs
		exec { "pear install phpcs":
				command => "/usr/bin/pear install --alldeps PHP_CodeSniffer",
				creates => '/usr/bin/phpcs',
				require => Exec['pear update-channels']
		}

		exec { 'PHPCS_Standards_TYPO3SniffPool':
				command => 'git clone git@github.com:typo3-ci/TYPO3SniffPool.git',
				creates => "/usr/share/php/PHP/CodeSniffer/Standards/TYPO3SniffPool",
				path    => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:./',
				cwd     => '/usr/share/php/PHP/CodeSniffer/Standards',
				user    => 'vagrant'
		}

		exec { 'PHPCS_Standards_TYPO3Flow':
				command => 'git clone git@github.com:typo3-ci/TYPO3Flow.git',
				creates => "/usr/share/php/PHP/CodeSniffer/Standards/TYPO3Flow",
				path    => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:./',
				cwd     => '/usr/share/php/PHP/CodeSniffer/Standards',
				user    => 'vagrant'
		}

		exec { 'PHPCS_Standards_TYPO3CMS':
				command => 'git clone git@github.com:typo3-ci/TYPO3CMS.git',
				creates => "/usr/share/php/PHP/CodeSniffer/Standards/TYPO3CMS",
				path    => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:./',
				cwd     => '/usr/share/php/PHP/CodeSniffer/Standards',
				user    => 'vagrant'
		}

		exec { "PHPCS_Standards-Permissions":
				command => 'chmod 777 Standards',
				path    => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:./',
				cwd     => "/usr/share/php/PHP/CodeSniffer",
				require => [
						Exec['pear install phpcs']
				]
		}

		exec { "PHPCS_Standards_MOC":
				command => '/usr/bin/git clone git@git.moc.net:/CodeSnifferRules/MOC.git /usr/share/php/PHP/CodeSniffer/Standards/MOC',
				creates => "/usr/share/php/PHP/CodeSniffer/Standards/MOC",
				user    => 'vagrant',
				require => [
						Exec['PHPCS_Standards-Permissions'],
						Ssh::Known_hosts ['git.moc.net']
				]
		}

		file { '/usr/local/bin/gerrit':
				ensure  => file,
				backup  => false,
				mode    => 755,
				owner   => root,
				group   => root,
				content => template("profile/devtools/gerrit.erb"),
		}

}