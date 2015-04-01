Puppet::Type.type(:postconf_entry).provide(:postconf) do

  commands :postconf => 'postconf'

  def self.instances
    entries = postconf('-n')
    entries.split("\n").collect do |line|
      name, value = line.split(' = ', 2)
 
      new(  :name   => name,
          :value  => value,
          :ensure => :present,
      )

    end
  end

  def self.prefetch(lists)
    instances.each do |prov|
      if list = lists[prov.name] || lists[prov.name.downcase]
        list.provider = prov
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  mk_resource_methods

  def value=(value)
    postconf('-e', "#{resource[:name]}=#{value}")
    @property_hash[:value] = value
  end

  def create
    postconf('-e', "#{resource[:name]}=#{resource[:value]}")
    @property_hash[:value] = resource[:value]
    @property_hash[:ensure] = :present
  end

  def destroy
    debug("Destroying #{resource[:name]}")
    postconf('-X', resource[:name])
  end

end
