
define flowsite::neos::import-site ($sitename, $package = $title)  {
	exec {'import-site':
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		cwd     => "/home/sites/${sitename}/flow",
		command => "php flow site:import --package-key=$package",
		unless => "mysql -uroot $sitename -e 'select * from typo3_neos_domain_model_site WHERE siteresourcespackagekey=\"$package\"' | grep $package"

	}
}
