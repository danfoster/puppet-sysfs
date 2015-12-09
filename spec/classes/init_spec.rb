require 'spec_helper'
describe 'sysfs' do

  context 'with defaults for all parameters' do
    it { should contain_class('sysfs') }
  end
end
