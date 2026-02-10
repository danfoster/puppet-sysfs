source 'https://rubygems.org'

puppet_version = ENV['PUPPET_VERSION']
if puppet_version
  gem 'puppet', puppet_version
else
  gem 'puppet', '>= 7.0'
end
gem 'facter', '>= 2.5'

# Required for newer Ruby versions (removed from stdlib)
gem 'logger'
gem 'ostruct'
gem 'bigdecimal'
gem 'racc'
gem 'base64'

group :development, :test do
  gem 'rake'
  gem 'rspec-puppet', '~> 2.12'
  gem 'puppetlabs_spec_helper', '~> 5.0'
  gem 'puppet-lint', '~> 3.0'
  gem 'metadata-json-lint'
end
