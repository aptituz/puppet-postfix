Puppet::Type.newtype(:postconf_entry) do
  ensurable

  newparam(:name, :namevar => true) do
  end

  newproperty(:value) do
  end

  newparam(:confdir) do
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
end
