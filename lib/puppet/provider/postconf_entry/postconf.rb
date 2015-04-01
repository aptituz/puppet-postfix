Puppet::Type.type(:postconf_entry).provide(:postconf) do

  commands :postconf => 'postconf'

  def self.instances
    self.fetch_resources('/etc/postfix')
  end

  def self.prefetch(resources)
    resources.each do |name, resource|
        confdir = resource[:confdir]
        settings = self.fetch_resources(confdir)

        if provider = settings.find{ |setting| setting.name == name }
            resources[name].provider = provider
        end
    end
  end

  def self.fetch_resources(confdir)
    args = [ '-c', confdir, '-n']
    entries = postconf(args)
    entries.split("\n").collect do |line|
      name, value = line.split(' = ', 2)
 
      new(  :name   => name,
          :value    => value,
          :ensure   => :present,
          :confdir  => '/etc/postfix',
      )

    end

  end

  def exists?
    @property_hash[:ensure] == :present
  end

  mk_resource_methods

  def value=(value)
    self.run_postconf('-e', "#{resource[:name]}=#{value}")
    @property_hash[:value] = value
  end

  def create
    self.run_postconf('-e', "#{resource[:name]}=#{resource[:value]}")
    @property_hash[:value] = resource[:value]
    @property_hash[:ensure] = :present
  end

  def destroy
    debug("Destroying #{resource[:name]}")
    self.run_postconf('-X', resource[:name])
  end

  def run_postconf(*args)
    debug("not doing anything")
    args = [ "-c", resource[:confdir], args ]
    postconf(args)
  end
end
