require 'beaker-rspec'

hosts.each do |host|
  on host, install_puppet
end


RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  
  c.formatter = :documentation
  puts "preparing"

  # Configure all nodes in nodeset
  c.before :suite do
    puts "Installing puppet module ..."
    puppet_module_install(:source => module_root, :module_name => 'postfix')
    
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
