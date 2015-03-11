define iwatch::path (
  $path = $name,
  $recurse = 'disabled',
  $syslog = 'enabled'
) {

  concat::fragment { "path_${path}":
    target => "$iwatch::iwatch_config_file",
    content => template('iwatch/iwatch-xml-path.erb'),
    order => 201,
  }
}
