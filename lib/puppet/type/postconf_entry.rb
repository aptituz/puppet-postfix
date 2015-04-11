Puppet::Type.newtype(:postconf_entry) do
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
   
  autorequire(:postfix_instance) do
    self[:instance]
  end
end
