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

  def self.run_postconf_with_instance(instance, args)
    postmulti('-i', instance, '-x', 'postconf', args)
  end

  def run_postconf(*args)
    instance = resource[:instance]
    if instance.nil?
      instance = '-'
    end
    self.class.run_postconf_with_instance(instance, args)
  end

  def set_conf_entry(key, value)
    args = [ '-e', "#{resource[:key]}=#{value}"]
    run_postconf(args)
  end

  def rm_conf_entry(key)
    args = [ '-X', key ]
    run_postconf(args)
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
