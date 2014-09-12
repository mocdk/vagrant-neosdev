class profile::elasticsearch {
	include profile::java

	apt::key { 'elasticsearch':
		key => 'D88E42B4',
		key_source => "http://packages.elasticsearch.org/GPG-KEY-elasticsearch"
	}

	apt::source { 'elasticsearch':
		location => 'http://packages.elasticsearch.org/elasticsearch/1.3/debian',
		release => 'stable',
		require => Apt::Key['elasticsearch'],
		include_src => false
	}

	package { "elasticsearch":
		ensure => "latest",
		require => Apt::Source['elasticsearch'],
	}

	service {'elasticsearch':
		ensure => "running",
		require => Package['java', 'elasticsearch'],
		enable => true,
	}

	file { "/etc/elasticsearch/elasticsearch.yml":
		content => template('profile/templates/elasticsearch/elasticsearch.yml.erb'),
		require => Package['elasticsearch'],
		notify => Service['elasticsearch'],
	}

}