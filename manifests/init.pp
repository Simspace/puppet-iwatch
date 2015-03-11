class iwatch () {
  $params = hiera('iwatch')

  $iwatch_defaults = {
    config_file => '/etc/iwatch/iwatch.xml',
    title => 'WatchList',
  }

  $iwatch_params = hiera('iwatch')

  package { 'iwatch':
    ensure => 'latest',
  }

  concat { $iwatch::config_file:
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  concat::fragment { "header":
    target => "$iwatch::config_file",
    content => template('iwatch/iwatch-xml-header.erb'),
    order => 100,
  }

  concat::fragment { "footer":
    target => "$iwatch::config_file",
    content => template('iwatch/iwatch-xml-footer.erb'),
    order => 900,
  }

  create_resources('iwatch::path', $iwatch_params, $iwatch_defaults)
}
