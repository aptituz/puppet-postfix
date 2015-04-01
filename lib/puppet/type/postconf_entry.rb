Puppet::Type.newtype(:postconf_entry) do
    ensurable

    newparam(:name, :namevar => true) do
    end

    newproperty(:value) do
    end

    newparam(:path) do
        defaultto '/etc/postfix/main.cf'

        validate do |val|
            unless Pathname.new(val).absolute?
                fail("File path must be fully qualified, not '#{val}'")
            end
        end
    end

#    autorequire(:file) do
#        self[:path] if self[:path] and Pathname.new(self:path).absolute?
#    end
end
