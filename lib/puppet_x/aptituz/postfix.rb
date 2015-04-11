require 'open3'
require 'puppet'

require 'puppetx'

module Puppetx::Aptituz
  module Puppetx::Aptituz::Postfix
    def self.run_postconf(instance_or_directory, args)
      postmulti = '/usr/sbin/postmulti'
      postconf  = '/usr/sbin/postconf'


      if instance_or_directory.nil?
        cmd = [postconf]
      elsif Pathname.new(instance_or_directory).absolute?
        cmd = [postconf, '-c', instance_or_directory]
      else
        cmd = [postmulti, '-i', instance_or_directory, '-x', 'postconf']
      end

      cmd = [cmd, args].join(" ")
      Puppet.debug("Executing command: '#{cmd}'") 
      Open3.capture3(cmd)
    end


      
    def self.get_instance_directories(config_dir)
      stdout_str, stderr_str, status =
        self.run_postconf(config_dir, 
          ['-h', 'queue_directory', 'data_directory']
        )
      stdout_str.split("\n")
    end

    def self.get_postfix_instances
      stdout_str, stderr_str, enabled = Open3.capture3('postmulti -l')
      entries = {}
      stdout_str.split("\n").each do |line|
        name, group, enabled, confdir = line.split(/\s+/,4)
        group   = (group == '-') ? nil : group
        enabled = (enabled == 'y') ? true : false 
        queue_directory, data_directory = self.get_instance_directories(confdir)
        entries[name] = {
          :group            => group,
          :enabled          => enabled,
          :config_directory => confdir,
          :queue_directory  => queue_directory,
          :data_directory   => data_directory,
        }
      end
      entries
    end
      
    def self.get_postconf_entries(instance = nil)
      stdout_str, stderr_str, enabled = self.run_postconf(instance, ['-n'])
      entries = {}
      stdout_str.split("\n").each do |line|
        name, value = line.split(" = ")
        entries[name] = value
      end
      entries
    end

    def self.set_postconf_values(instance, key_value_pairs)
      settings = key_value_pairs.each.collect { |k,v| "#{k}=#{v}" }
      stdout_str, stderr_str, status = self.run_postconf(instance, ['-e', settings])
    
      unless status.success?
        raise Puppet::Error, "unable to set postconf values: #{stdout_str} #{stderr_str}"
      end
      
    end

    def self.remove_postconf_values(instance, keys)
      stdout_str, stderr_str, status = self.run_postconf(instance, ['-X', keys])

      unless status.success?
        raise Puppet::Error, "unable to set postconf values: #{stdout_str} #{stderr_str}"
      end
    end

  end
end
