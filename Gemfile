source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "#{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['~> 3.8.7']
end

#group :development do
#  gem 'guard-rake', :require => false
#end

group :unit_tests, :development do
  gem 'sshkey'
  gem 'puppet', puppetversion

  gem 'puppetlabs_spec_helper', '~> 1.2.2', :require => false
  gem 'rspec'
  gem 'rspec-puppet'
  gem 'puppet-blacksmith', :require => false

  gem 'rspec-puppet-facts', :require => false
  gem 'puppet-lint-absolute_classname-check', :require => false
  gem 'puppet-lint-leading_zero-check', :require => false
  gem 'puppet-lint-version_comparison-check', :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check', :require => false
  gem 'puppet-lint-unquoted_string-check', :require => false
  gem 'puppet-lint-variable_contains_upcase', :require => false
  gem 'metadata-json-lint', :require => false
  gem 'puppet-strings', '0.4.0', :require => false
  gem 'rubocop-rspec', '~> 1.6', :require => false if RUBY_VERSION >= '2.3.0'
  gem 'json_pure'
end

group :system_tests do
  gem 'beaker', '~> 2.0'
  gem 'beaker-rspec'
  gem 'pry'
end
