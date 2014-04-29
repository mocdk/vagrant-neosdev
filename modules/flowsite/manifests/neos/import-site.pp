
define flowsite::neos::import-site ($sitename, $package = $title)  {
	exec {"import-site-${sitename}-${package}":
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		cwd     => "/home/sites/${sitename}/flow",
		command => "php flow site:import --package-key=$package",
		unless => "php flow site:list | grep '${package}'"
	}
}
