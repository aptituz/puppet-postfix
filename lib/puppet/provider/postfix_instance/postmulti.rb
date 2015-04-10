Puppet::Type.type(:postfix_instance).provide(:postmulti) do
  
  commands :postmulti => 'postmulti'
  commands :postconf  => 'postconf'

  def self.get_instance_directories(dir)
    postconf('-c', dir, '-h', 'queue_directory', 'data_directory').split("\n")
  end 
    
  def self.get_postfix_instances
    postmulti('-l').split("\n").collect do |line|
      name, group, default, directory = line.split(/\s+/, 4)
      queue_directory, data_directory = self.get_instance_directories(directory)
      { :name             => name,
        :group            => group,
        :default          => default,
        :config_directory => directory,
        :queue_directory  => queue_directory,
        :data_directory   => data_directory,
    
      }
    end
  end

  def self.instances
    instances = self.get_postfix_instances.select { |i| i[:default] != 'y' }
    instances.collect do |instance|
      new(  :name              => instance[:name],
            :ensure            => :present,
            :config_directory  => instance[:config_directory],
            :queue_directory   => instance[:queue_directory],
            :data_directory    => instance[:data_directory],
      )
    end
  end

  def self.prefetch(resources)
    postfix_instances = Hash[self.instances.map{|i| [i.name, i]}]
    resources.each do |name,resource|
      if prov = postfix_instances[name]
        resources[name].provider = prov
      end
    end
  end    

  mk_resource_methods

  def exists?
    @property_hash[:ensure] == :present
  end 

  def create
    cmd = 'create'
    args = [ "config_directory=#{resource[:config_directory]}" ]
    if Dir.exists?(@resource[:config_directory])
      cmd = 'import'
    else
      args.push("queue_directory=#{resource[:queue_directory]}",
                "data_directory=#{resource[:data_directory]}")
    end

    begin
      cmd = ['postmulti', '-e', cmd, '-I', self.name, args].join(" ")
      debug("Executing '#{cmd}'")
      stdout_str, stderr_str, status = 
        Open3.capture3(cmd)
        debug(stdout_str)
    rescue SystemCallError => e
      raise Puppet::Error, "Could not run postmulti #{self.name}: #{stderr_str}", $!.backtrace
      return nil
    end

    if status.success?
      @property_hash[:ensure] = :present
    else
      raise Puppet::Error, "Failed to add or import instance #{self.name}: #{stdout_str}"
    end
  end

  def destroy
    postmulti( '-e', 'destroy', '-i', @resource[:name])
  end
end

