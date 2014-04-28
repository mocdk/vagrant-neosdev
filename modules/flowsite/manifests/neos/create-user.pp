define flowsite::neos::create-user ($username = $title, $password, $sitename, $firstname, $lastname, $role = 'Administrator') {
	exec {'create-user':
		path    => '/usr/bin:/bin:/usr/sbin:/sbin:./',
		cwd     => "/home/sites/${sitename}/flow",
		command => "php flow user:create --username=$username --password=$password --roles='$role' --first-name='$firstname' --last-name='$lastname'",
		unless => "mysql -uroot $sitename -e 'select * from typo3_flow_security_account WHERE  accountidentifier=\"$username\"' | grep $username"
	}
}