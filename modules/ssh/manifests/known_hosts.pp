
define ssh::known_hosts ($username, $hostname = $title, $homedir = "/home/${username}") {

	if !defined(File["${homedir}/.ssh"]) {
		file { "${homedir}/.ssh":
			ensure => directory,
			owner => 'vagrant',
			mode => 0600
		}
	}

	if !defined(File["${homedir}/.ssh/known_hosts"]) {
		file { "${homedir}/.ssh/known_hosts":
			ensure => present,
			owner => $username,
			mode => 0600,
			require => File["${homedir}/.ssh"]
		}
	}

	exec {"${hostname}-hostkey":
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		user => $username,
		command => "ssh-keyscan -H ${hostname} >> ${homedir}/.ssh/known_hosts",
		require => File["${homedir}/.ssh/known_hosts"],
		unless => "ssh-keygen -H -F $hostname | grep found"
	}

}