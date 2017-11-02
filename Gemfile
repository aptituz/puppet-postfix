source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['~> 3.7']

group :development, :unit_tests do
  gem 'puppet', puppetversion
  gem 'puppetlabs_spec_helper', '>= 1.0.0'
  gem 'puppet-lint', '>= 1.0.0'
  gem 'facter', '>= 1.7.0'
  gem 'facterdb'
  gem 'rspec-puppet'
  gem 'rspec_junit_formatter'
  gem 'rspec-puppet-facts'
  gem 'rgen'
  gem 'puppet-strings'
end

group :system_tests, optional: true do
  # 3.x.x branch requires ruby 2.2.5, probably too new for most of us ;)
  gem 'beaker', '~> 2.51.0'
  gem 'beaker-rspec', '~> 5.6.0'
end
