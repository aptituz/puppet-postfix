Puppet::Type.newtype(:postfix_config) do
  desc "Puppet type that allows setting postfix configuration settings"
  ensurable

  newparam(:name, :namevar => true) do
    desc "the name of the configuration setting (used for uniqueness)"
  end

  newparam(:key) do
    desc "the configuration key to be changed (defaults to name)"
    defaultto { @resource[:name] }
  end

  newproperty(:value) do
    desc "which value to set on the specified key"
  end

  newproperty(:instance) do
    desc "the instance to which the configuration setting belongs"
    defaultto { nil }
  end
   
  newparam(:confdir) do
    desc "Optional: the confdir in which postfix configurations reside. Thats
          most useful when working with multiple instances of postfix and
          therefore defaults to '/etc/postfix'"
    defaultto '/etc/postfix'


    validate do |val|
      unless Pathname.new(val).absolute?
        fail("confdir must be fully qualified, not '#{val}'")
      end
    end
  end

  autorequire(:file) do
    File.join(self[:confdir], 'main.cf')
  end

  autorequire(:postfix_instance) do
    self[:instance]
  end
end
