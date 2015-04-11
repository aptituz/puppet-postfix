require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "puppet_x", "aptituz", "postfix.rb"))

Puppet::Type.type(:postconf_entry).provide(:postconf) do

  commands :postconf => 'postconf'
  commands :postmulti => 'postmulti'

  def self.instances
    self.fetch_resources(nil)
  end

  def self.prefetch(resources)
    postfix_instances = resources.map { |name, resource| resource[:instance] }.uniq
    postfix_instances.each do |instance|
        settings = self.fetch_resources(instance)

        # match resources with same instance and key, not name since
        # this is not neccesarily distinct
        resources.each do |name, resource|
            if prov = settings.find { |entry| entry.key == resource[:key] and instance == resource[:instance] }
              resources[name].provider = prov
            end
        end
    end
  end

  def self.fetch_resources(instance)
    Puppetx::Aptituz::Postfix.get_postconf_entries(instance).collect do |name, value|
      new(  :name   => "#{name}",
          :key      => name,
          :value    => value,
          :ensure   => :present,
          :instance  => instance,
      )
    end

  end

  def exists?
    @property_hash[:ensure] == :present
  end

  mk_resource_methods

  def value=(value)
    Puppetx::Aptituz::Postfix.set_postconf_values(
      resource[:instance], resource[:key] => resource[:value])
    @property_hash[:value] = value
  end

  def create
    unless Puppetx::Aptituz::Postfix.get_postfix_instances[resource[:instance]]
      raise Puppet::Error, "no postfix instance named '#{resource[:instance]}' exists"
    end

    Puppetx::Aptituz::Postfix.set_postconf_values(
      resource[:instance], resource[:key] => resource[:value])
    @property_hash[:value] = resource[:value]
    @property_hash[:ensure] = :present
  end

  def destroy
    Puppetx::Aptituz::Postfix.remove_postconf_values(
      resource[:instance], resource[:key]
    )
  end

end
