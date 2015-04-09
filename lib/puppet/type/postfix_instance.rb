Puppet::Type.newtype(:postfix_instance) do
  desc "Manage postfix instances"
  ensurable

  newparam(:name, :namevar => true) do
    desc "the name of the postfix instance"
  end

  newparam(:config_directory) do
    desc "Where the configuration of this instance will be stored 
          (defaults to /etc/name)"

    defaultto { File.join("/etc", @resource[:name])  }
  end

  newparam(:queue_directory) do
    desc "the queue directory of the instance
          (defaults to /var/spool/name)"

    defaultto { File.join("/var/spool", @resource[:name]) }
  end

  newparam(:data_directory) do
    desc "the data directory of the instance
          (defaults to /var/lib/name)"

    defaultto { File.join("/var/lib", @resource[:name]) }
  end
end
