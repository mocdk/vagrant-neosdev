class profile::venstre {
	include profile::web
	include profile::php
	include profile::devtools
	include profile::db
	include profile::memcached
	include profile::elasticsearch

	class { 'apt::backports':
	}

}