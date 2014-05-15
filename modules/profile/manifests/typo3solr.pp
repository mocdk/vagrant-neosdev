class profile::typo3solr {
	include profile::java

	package { 'tomcat6': ensure => installed}
	package { 'tomcat6-user': require => Package['tomcat6'], ensure => installed}
	package { 'tomcat6-admin': require => Package['tomcat6'], ensure => installed}
	service { 'tomcat': name => 'tomcat6', ensure => running, require => Package['tomcat6'] }

	$tomcatRootDir = '/var/lib/tomcat6'
 	$solrHomeDir = '/home/solr'

	file { "/var/lib/tomcat6/webapps/solr.war":
		owner => 'root',
		source => "puppet:///modules/profile/typo3solr/solr.war",
		require => Package['tomcat6'],
		notify => Service['tomcat']
	}

	file { "$tomcatRootDir/conf/Catalina/localhost/solr.xml":
		owner => "tomcat6",
		group => "tomcat6",
		content => template('profile/typo3solr/tomcatSolr.xml.erb'),
		require => Package['tomcat6'],
		notify => Service['tomcat6']
	}

	file { "$solrHomeDir":
		owner => "tomcat6",
		group => "tomcat6",
		recurse => "true",
		source  => 'puppet:///modules/profile/typo3solr/homedir/',
		require => Package['tomcat6'],
		notify => Service['tomcat6']
	}
}

#MAke definitionfor solr core, using concat etc.