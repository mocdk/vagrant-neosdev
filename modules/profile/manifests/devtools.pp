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
		ensure   => 'installed',
		provider => 'gem',
		install_options => '--pre'
	}

	package { 'sass':
		ensure   => 'installed',
		provider => 'gem',
		install_options => '--pre'
	}

}