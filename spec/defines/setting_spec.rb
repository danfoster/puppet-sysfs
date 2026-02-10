require 'spec_helper'

describe 'sysfs::setting' do
  let(:pre_condition) { 'include sysfs' }

  let(:facts) do
    {
      os: {
        'family' => 'RedHat',
        'name' => 'CentOS',
        'release' => {
          'full' => '8.0',
          'major' => '8',
          'minor' => '0',
        },
      },
      kernel: 'Linux',
    }
  end

  context 'with a simple setting' do
    let(:title) { 'class/block/sda/queue/read_ahead_kb' }
    let(:params) { { value: '256' } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_concat__fragment('class/block/sda/queue/read_ahead_kb').with(
        'target'  => '/etc/sysfs.conf',
        'content' => "class/block/sda/queue/read_ahead_kb=256\n",
      )
    end
  end

  context 'with rotational setting' do
    let(:title) { 'class/block/sdb/queue/rotational' }
    let(:params) { { value: '0' } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_concat__fragment('class/block/sdb/queue/rotational').with(
        'target'  => '/etc/sysfs.conf',
        'content' => "class/block/sdb/queue/rotational=0\n",
      )
    end
  end

  context 'with scheduler setting' do
    let(:title) { 'block/sda/queue/scheduler' }
    let(:params) { { value: 'deadline' } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_concat__fragment('block/sda/queue/scheduler').with(
        'target'  => '/etc/sysfs.conf',
        'content' => "block/sda/queue/scheduler=deadline\n",
      )
    end
  end

  context 'with numeric value' do
    let(:title) { 'kernel/mm/transparent_hugepage/enabled' }
    let(:params) { { value: 'never' } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_concat__fragment('kernel/mm/transparent_hugepage/enabled').with(
        'target'  => '/etc/sysfs.conf',
        'content' => "kernel/mm/transparent_hugepage/enabled=never\n",
      )
    end
  end

  context 'with integer value' do
    let(:title) { 'class/net/eth0/queues/rx-0/rps_cpus' }
    let(:params) { { value: 15 } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_concat__fragment('class/net/eth0/queues/rx-0/rps_cpus').with(
        'target'  => '/etc/sysfs.conf',
        'content' => "class/net/eth0/queues/rx-0/rps_cpus=15\n",
      )
    end
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

    let(:title) { 'class/block/sda/queue/nr_requests' }
    let(:params) { { value: '128' } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_concat__fragment('class/block/sda/queue/nr_requests').with(
        'target'  => '/etc/sysfs.conf',
        'content' => "class/block/sda/queue/nr_requests=128\n",
      )
    end
  end
end
