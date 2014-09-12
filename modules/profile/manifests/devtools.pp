class profile::devtools {

	$devpackagelist = [
		"ruby-compass"
	]

	$devBackportsPackagelist = [
		"git-man",
		"git"
	]

	package { $devpackagelist:
		ensure => present,
	}

	apt::force { $devBackportsPackagelist:
	  release => 'wheezy-backports',
	  require => Apt::Source['backports'],
	}

}