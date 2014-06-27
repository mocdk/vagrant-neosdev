class profile::devtools {

	$devpackagelist = [
		"git/wheezy-backports",
		"ruby-compass"
	]

	package { $devpackagelist:
		ensure => present,
		require => Apt::Source['backports']
	}

}