class iwatch {
  $iwatch_config_file = hiera('iwatch::config_file', '/etc/iwatch/iwatch.xml')
  $iwatch_title = hiera('iwatch::title', 'iWatch Default')
  $iwatch_params = hiera('iwatch::path')
  $iwatch_syslog = hiera('iwatch::syslog', 'default')

  class { 'rsyslog':
    default_config => true,
  }

  if $iwatch_syslog != 'default' {
    rsyslog::snippet { '10-iwatch':
      lines => [ ":programname, isequal, \"iWatch\" @@${iwatch_syslog}", '& ~' ]
    }
  }

  package { 'iwatch':
    ensure => 'latest',
  }

  concat { $iwatch_config_file:
    owner => 'root',
    group => 'root',
    mode => '0644',
    notify => Service['iwatch'],
  }

  concat::fragment { "header":
    target => "$iwatch_config_file",
    content => template('iwatch/iwatch-xml-header.erb'),
    order => 100,
  }

  concat::fragment { "footer":
    target => "$iwatch_config_file",
    content => template('iwatch/iwatch-xml-footer.erb'),
    order => 900,
  }

  create_resources('iwatch::path', $iwatch_params)

  service { 'iwatch':
    enable => 'true',
    ensure => 'running',
  }

  file_line { '/etc/default/iwatch':
    match => 'START_DAEMON=false',
    line => 'START_DAEMON=true',
    notify => Service['iwatch'],
  }
}
