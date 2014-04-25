class profile::mocnet {
	include profile::web
	include profile::php
	include profile::devtools

	class { 'apt::backports':
	}

	flowsite::site {'flowsite':
		require => Class['profile::devtools']
	}

#	flowsite::site {'mochosting':
#		repository => 'http://packages.moc.net/',
#		basedistribution => 'moc/flow-mochosting-distribution',
#		url => 'mochosting.dev'
#	}

}