require 'spec_helper'

describe 'sysfs' do
  context 'with default parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('sysfs') }

    # Package management
    it { is_expected.to contain_package('sysfsutils').with_ensure('installed') }

    # Configuration file
    it do
      is_expected.to contain_concat('/etc/sysfs.conf').with(
        'owner' => 'root',
        'group' => 'root',
        'mode'  => '0644',
      )
    end

    it { is_expected.to contain_concat('/etc/sysfs.conf').that_requires('Package[sysfsutils]') }

    # Service management
    it do
      is_expected.to contain_service('sysfsutils').with(
        'ensure' => 'running',
        'enable' => true,
      )
    end

    it { is_expected.to contain_service('sysfsutils').that_subscribes_to('Concat[/etc/sysfs.conf]') }
  end

  context 'with settings parameter' do
    let(:params) do
      {
        settings: {
          'class/block/sda/queue/read_ahead_kb' => { 'value' => '256' },
          'class/block/sdb/queue/rotational'    => { 'value' => '0' },
        },
      }
    end

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_sysfs__setting('class/block/sda/queue/read_ahead_kb').with(
        'value' => '256',
      )
    end

    it do
      is_expected.to contain_sysfs__setting('class/block/sdb/queue/rotational').with(
        'value' => '0',
      )
    end
  end

  # RedHat 7+ specific tests
  context 'on RedHat 7+' do
    let(:facts) do
      {
        os: {
          'family' => 'RedHat',
          'name' => 'CentOS',
          'release' => {
            'full' => '7.9',
            'major' => '7',
            'minor' => '9',
          },
        },
        kernel: 'Linux',
      }
    end

    it { is_expected.to compile.with_all_deps }

    # Custom reload script for RHEL 7+
    it do
      is_expected.to contain_file('/usr/local/bin/sysfs-reload').with(
        'source' => 'puppet:///modules/sysfs/sysfs-reload',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0700',
      )
    end

    it { is_expected.to contain_file('/usr/local/bin/sysfs-reload').that_comes_before('File[/etc/systemd/system/sysfsutils.service]') }

    # Systemd service unit
    it do
      is_expected.to contain_file('/etc/systemd/system/sysfsutils.service').with(
        'source' => 'puppet:///modules/sysfs/sysfsutils.service',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0444',
      )
    end

    it { is_expected.to contain_file('/etc/systemd/system/sysfsutils.service').that_comes_before('Service[sysfsutils]') }

    # Exec for reloading sysfs settings
    it do
      is_expected.to contain_exec('sysfsutils_reload_rhel').with(
        'refreshonly' => true,
      )
    end

    it { is_expected.to contain_exec('sysfsutils_reload_rhel').that_subscribes_to('Concat[/etc/sysfs.conf]') }
  end

  context 'on RedHat 8+' do
    let(:facts) do
      {
        os: {
          'family' => 'RedHat',
          'name' => 'AlmaLinux',
          'release' => {
            'full' => '8.5',
            'major' => '8',
            'minor' => '5',
          },
        },
        kernel: 'Linux',
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/usr/local/bin/sysfs-reload') }
    it { is_expected.to contain_file('/etc/systemd/system/sysfsutils.service') }
    it { is_expected.to contain_exec('sysfsutils_reload_rhel') }
  end

  context 'on RedHat 6 (pre-systemd)' do
    let(:facts) do
      {
        os: {
          'family' => 'RedHat',
          'name' => 'CentOS',
          'release' => {
            'full' => '6.10',
            'major' => '6',
            'minor' => '10',
          },
        },
        kernel: 'Linux',
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.not_to contain_file('/usr/local/bin/sysfs-reload') }
    it { is_expected.not_to contain_file('/etc/systemd/system/sysfsutils.service') }
    it { is_expected.not_to contain_exec('sysfsutils_reload_rhel') }
  end

  context 'on Debian' do
    let(:facts) do
      {
        os: {
          'family' => 'Debian',
          'name' => 'Ubuntu',
          'release' => {
            'full' => '22.04',
            'major' => '22',
            'minor' => '04',
          },
        },
        kernel: 'Linux',
      }
    end

    it { is_expected.to compile.with_all_deps }

    # Should NOT have RHEL-specific resources
    it { is_expected.not_to contain_file('/usr/local/bin/sysfs-reload') }
    it { is_expected.not_to contain_file('/etc/systemd/system/sysfsutils.service') }
    it { is_expected.not_to contain_exec('sysfsutils_reload_rhel') }

    # Should still have common resources
    it { is_expected.to contain_package('sysfsutils') }
    it { is_expected.to contain_service('sysfsutils') }
    it { is_expected.to contain_concat('/etc/sysfs.conf') }
  end
end
