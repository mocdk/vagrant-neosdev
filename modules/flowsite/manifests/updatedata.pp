define flowsite::updatedata ($sitename = $title, $datapath = "www-data@fermi:/home/site-repository/websites/${title}.xml") {

	ssh::known_hosts {'fermi':
		username => 'root',
		homedir => '/root'
	}

	#Import file via SSH
	#exec {"import-${title}":
	#	path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
	#	command => "scp $datapath ${title}.xml",
	#	cwd => '/tmp/',
	#	user => 'vagrant'
	#}

	#Run import
	exec {"import-site-from-file-${sitename}":
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		cwd     => "/home/sites/${sitename}/flow",
		command => "php flow site:import --filename=/tmp/${title}.xml"
	}
}