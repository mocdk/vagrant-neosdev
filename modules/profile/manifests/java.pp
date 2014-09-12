class profile::java {

	package { 'java':
		name => 'openjdk-7-jre-headless',
		ensure => 'installed'
	}

	#Since java6 is preinstalled on the box, we need to update the alternatives to force java7 as default jre
	exec { "update-alternatives --set java /usr/lib/jvm/java-7-openjdk-i386/jre/bin/java":
	  unless => 'test $(readlink /etc/alternatives/java) == "/usr/lib/jvm/java-7-openjdk-i386/jre/bin/java"',
	  require => Package["java"],
	  path => ["/usr/bin", "/usr/sbin", "/bin"]
	}

}