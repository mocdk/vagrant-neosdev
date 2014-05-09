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
		ensure                   => 'present'
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