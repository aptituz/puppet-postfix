source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.7']
end

gem 'rake'
gem 'puppet-lint'
gem 'rspec', '< 2.99'
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet', puppetversion
