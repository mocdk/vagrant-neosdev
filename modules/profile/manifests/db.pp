class profile::db {
	class { '::mysql::server':
		#root_password    => 'Gei5XuxaiYee',
		override_options => {
			'mysqld' => {
				'max_connections' => '1024',
				'character_set_server' => 'utf8',
				'collation_server' => 'utf8_danish_ci'
			}
		}
	}

}