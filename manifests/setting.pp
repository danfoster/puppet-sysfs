define sysfs::setting($value) {
  concat::fragment { "${name}":
    target => "/etc/sysfs.conf",
    content => "${name}=${value}\n";
  }
}
