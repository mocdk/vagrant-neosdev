class profile::base {
	class {'apt':
		purge_sources_list => true,
		purge_sources_list_d => true,
		always_apt_update => true
	}

	apt::source { 'main':
		#location => 'http://ftp.dk.debian.org/debian/',
		#location => 'http://mirrors.dotsrc.org/debian/',
		location => 'http://ftp2.de.debian.org/debian/',
		repos => 'main contrib non-free'
	}

	#Make the apt source main run first
	Apt::Source['main']  -> Package <| |>
	#deb http://ftp.dk.debian.org/debian/ wheezy main contrib non-free

	# Base packages
	$packagelist = [
		"libaugeas-ruby", #Needed for puppet to run correctly
		"less",
		"htop",
		"iftop",
		"ngrep",
		"nload",
		"strace",
		"tcpdump",
		"mtr",
		"emacs",
		"yaml-mode",
		"php-elisp",
		"locate",
		"vim",
		"vim-runtime",
		"vim-scripts",
		"vim-puppet",
		"pv",
		"bzip2",
		"curl",
		"links",
		"netcat",
		"unzip",
		"zip",
		"screen",
		"sysstat",	# for nagios/nrpe
		"nmap",
		"lsof",
		"ntpdate",
		"ntp",
        "daemon",
        "lsb-base",
        "lsb-release",
		"pciutils",
		"rubygems"

	]

	package { $packagelist:
		ensure => present,
		require => Apt::Source['main']
	}

}