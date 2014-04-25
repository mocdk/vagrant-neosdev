class profile::devtools {

	$devpackagelist = [
		"git",
		"ruby-compass"
	]

	package { $devpackagelist:
		ensure => present,
		require => Apt::Source['backports']
	}

}