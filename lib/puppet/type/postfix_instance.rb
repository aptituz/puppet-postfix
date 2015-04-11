Puppet::Type.newtype(:postfix_instance) do
  desc "Manage postfix instances"
  ensurable

  newparam(:name, :namevar => true) do
    desc "the name of the postfix instance"
  end

  newproperty(:config_directory) do
    desc "Where the configuration of this instance will be stored 
          (defaults to /etc/name)"

    defaultto { File.join("/etc", @resource[:name])  }
  end

  newproperty(:group) do
    desc "Where the configuration of this instance will be stored"
  end

  newproperty(:queue_directory) do
    desc "the queue directory of the instance
          (defaults to /var/spool/name)"

    defaultto { File.join("/var/spool", @resource[:name]) }
  end

  newproperty(:data_directory) do
    desc "the data directory of the instance
          (defaults to /var/lib/name)"

    defaultto { File.join("/var/lib", @resource[:name]) }
  end

  newproperty(:enabled) do
   desc "weither the instance should be enabled or not
        (default: true)

This refers to the multi_instance_enable configuration option of the instance."
   defaultto { true }
  end

  autorequire(:package) { [ 'postfix'] }
end
