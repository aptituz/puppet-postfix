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
    postmulti(  '-e', 'create', '-I', @resource[:name], 
                "config_directory=#{resource[:config_directory]}",
                "queue_directory=#{resource[:queue_directory]}",
                "data_directory=#{resource[:data_directory]}"
    )
    @property_hash[:ensure] = :present
    print @resource[:config_directory]
  end

  def destroy
    postmulti( '-e', 'destroy', '-i', @resource[:name])
  end
end
 
