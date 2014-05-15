class supervisor {

	package {'supervisor': ensure => installed }

	service {'supervisor': ensure => running}

}

define supervisor::command (
	$command,
	$user,
	$autostart = "true",
	$exitcodes = "0,2",
	$stdout_logfile = "",
	$stdout_logfile_maxbytes = "50MB",
	$stderr_logfile = "",
	$stderr_logfile_maxbytes = "50MB"
	) {

	file { "/etc/supervisor/conf.d/$title.conf":
		content => template('supervisor/command.conf.erb'),
		require => Package['supervisor'],
		notify => Service['supervisor']
	}


}
