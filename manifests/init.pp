# == Class: sysfs
#
# A module for managing sysfs settings.
#
# === Examples
#
#  class { 'sysfs':
#  }
#
# === Authors
#
# Dan Foster <dan@zem.org.uk>
#
# === Copyright
#
# Copyright 2015 Dan Foster, unless otherwise noted.
#
class sysfs (
  $settings  = undef
) {
  package { 'sysfsutils':
    ensure => installed
  }

  if ($::osfamily == 'RedHat') and ($::operatingsystemmajrelease == '7')  {
    file { '/usr/local/bin/sysfs-reload' :
      source => 'puppet:///modules/sysfs/sysfs-reload',
      owner  => root,
      group  => root,
      mode   => '0700',
      before => File['/etc/systemd/system/sysfsutils.service']
    }
    file { '/etc/systemd/system/sysfsutils.service' :
      source => 'puppet:///modules/sysfs/sysfsutils.service',
      owner  => root,
      group  => root,
      mode   => '0700',
      before => Service['sysfsutils'],
    }
    exec { 'sysfsutils_reload_rhel':
      command     => '/usr/bin/awk -F= \'/(\S+)\s*=(\S+)/{cmd=sprintf("/bin/echo %s > /sys/%s",$2, $1); system(cmd)}\' /etc/sysfs.conf',
      refreshonly => true,
      subscribe   => Concat['/etc/sysfs.conf'],
    }
  }

  service { 'sysfsutils':
    ensure    => running,
    enable    => true,
    subscribe => Concat['/etc/sysfs.conf'],
  }

  concat { '/etc/sysfs.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['sysfsutils'],
  }

  if is_hash($settings) {
    create_resources('sysfs::setting', $settings)
  }

}
