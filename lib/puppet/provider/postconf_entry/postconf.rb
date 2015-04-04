Puppet::Type.type(:postconf_entry).provide(:postconf) do

  commands :postconf => 'postconf'

  def self.instances
    self.fetch_resources('/etc/postfix')
  end

  def self.prefetch(resources)
    confdirs = resources.map { |name, resource| resource[:confdir] }.uniq
    confdirs.each do |confdir|
        settings = self.fetch_resources(confdir)

        resources.keys.each do |name|
            if setting = settings.find{ |setting| setting.name == name }
                resources[name].provider = setting
            end
        end
    end
  end

  def self.run_postconf_with_confdir(confdir, args)
    postconf('-c', confdir, args)
  end

  # FIXME: mxey said that this should probably return a list or even a hash of
  # key value pairs. He's right. Could be fixed someday.
  def self.list_conf_entries(confdir)
    self.run_postconf_with_confdir(confdir, '-n').split("\n").collect do |line|
        name, value = line.split(' = ', 2)
        yield name, value if block_given?
        [name, value]
    end
  end


  def run_postconf(*args)
    confdir = resource[:confdir]
    self.class.run_postconf_with_confdir(confdir, args)
  end

  def set_conf_entry(key, value)
    args = [ '-e', "#{resource[:key]}=#{value}"]
    run_postconf(args)
  end

  def rm_conf_entry(key)
    args = [ '-X', key ]
    run_postconf(args)
  end

  def self.fetch_resources(confdir)
    self.list_conf_entries(confdir).collect do |name, value|
      new(  :name   => name,
          :key      => name,
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
    set_conf_entry(resource[:key], value)
    @property_hash[:value] = value
  end

  def create
    set_conf_entry(resource[:key], resource[:value]) 
    @property_hash[:value] = resource[:value]
    @property_hash[:ensure] = :present
  end

  def destroy
    rm_conf_entry(resource[:key])
  end

end
