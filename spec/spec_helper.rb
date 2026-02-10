require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    os: {
      'family' => 'RedHat',
      'name' => 'CentOS',
      'release' => {
        'full' => '8.0',
        'major' => '8',
        'minor' => '0',
      },
    },
    osfamily: 'RedHat',
    operatingsystem: 'CentOS',
    operatingsystemrelease: '8.0',
    kernel: 'Linux',
  }

  c.before(:each) do
    Puppet::Util::Log.level = :warning
    Puppet::Util::Log.newdestination(:console)
  end
end
