class profile::php {
	include php
	include php::params
	include php::pear
	include php::composer
	include mailcatcher

	# Extensions must be installed before they are configured
	Php::Extension <| |> -> Php::Config <| |>

	# Ensure base packages is installed in the correct order
	# and before any php extensions
	Package['php5-common']
		-> Package['php5-dev']
		-> Package['php5-cli']
		-> Php::Extension <| |>

	class {
		# Base packages
		[ 'php::dev', 'php::cli' ]:
			ensure => installed;

		# PHP extensions
		[
			'php::extension::curl', 'php::extension::gd', 'php::extension::imagick',
			'php::extension::mcrypt', 'php::extension::mysql'
		]:
		ensure => $version;
	}

	php::config { 'set-timezone-to-copenhagen':
		file => '/etc/php5/conf.d/20-timezone.ini',
		config  => [
			'set .anon/date.timezone Europe/Copenhagen'
		]
	}

}