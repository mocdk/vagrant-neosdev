class profile::devtools {

	$devpackagelist = [
		"git-man/wheezy-backports",
		"git/wheezy-backports",
		"ruby-compass"
	]

	package { $devpackagelist:
		ensure => present,
		require => Apt::Source['backports']
	}

}