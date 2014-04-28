class profile::neosdemosite {
	include profile::web
	include profile::php
	include profile::devtools
	include profile::db

	class { 'apt::backports':
	}

	flowsite::site {'neossite':
		require => Class['profile::devtools'],
		basedistribution => 'typo3/neos-base-distribution',
		url => 'neosdemo.dev'
	}

	flowsite::neos::create-user {'neosadmin':
		username => 'neosadmin',
		password => 'neosadmin',
		firstname => 'MOC',
		lastname => 'Editor',
		role => 'Administrator',
		sitename => 'neossite',
		require => Flowsite::Site['neossite']
	}

	flowsite::neos::import-site {'TYPO3.NeosDemoTypo3Org':
		sitename => 'neossite',
		package => 'TYPO3.NeosDemoTypo3Org',
		require => Flowsite::Site['neossite']
	}

}