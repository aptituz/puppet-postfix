Puppet::Type.type(:postconf_entry).provide(:postconf) do

  commands :postconf => 'postconf'

  def self.instances
    self.fetch_resources('/etc/postfix')
  end

  def self.prefetch(resources)
    confdirs = resources.map { |name, resource| resource[:confdir] }.uniq
    confdirs.each do |confdir|
        settings = self.fetch_resources(confdir)

        if settings = settings.find{ |setting| setting.name == name }
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
    self.run_postconf('-e', "#{resource[:key]}=#{value}")
    @property_hash[:value] = value
  end

  def create
    self.run_postconf('-e', "#{resource[:key]}=#{resource[:value]}")
    @property_hash[:value] = resource[:value]
    @property_hash[:ensure] = :present
  end

  def destroy
    self.run_postconf('-X', resource[:key])
  end

  def run_postconf(*args)
    debug("not doing anything")
    args = [ "-c", resource[:confdir], args ]
    postconf(args)
  end
end
