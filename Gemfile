source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 3.7']
end

gem 'rake'
gem 'puppet-lint'
gem 'rspec'
gem 'rspec-puppet'
gem 'rspec-mocks'
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet', puppetversion

#ägem 'beaker', :require => false
#ägem 'beaker-rspec', :require => false
gem 'pry', :require => false
