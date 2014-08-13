class profile::db {
	class { '::mysql::server':
		override_options => {
			'mysqld' => {
				'max_connections' => '1024',
				'character_set_server' => 'utf8',
				'collation_server' => 'utf8_danish_ci',
				'bind-address' => '*'
			}
		}
	}

	#Make a root user accessible for all networks, with access to all db's
	mysql_user { 'root@%':
		ensure			=> 'present',
		password_hash	=> '*04E6E1273D1783DF7D57DC5479FE01CFFDFD0058'
	}

	mysql_grant { 'root@network/*.*':
		ensure     => 'present',
		options    => ['GRANT'],
		privileges => ['ALL'],
		table      => '*.*',
		user       => 'root@%',
		require	=> Mysql_user['root@%']
	}
}