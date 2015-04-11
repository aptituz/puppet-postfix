Puppet::Type.newtype(:postfix_service) do
  desc "Puppet type that allows management of postfix service processes

The Postfix mail system consists of some client commands and of a large number of services running in the background. Those services are managed in the master.cf configuration file and this type allows to manage them.
"
  ensurable

  newparam(:name, :namevar => true) do
    desc "the name of the configuration setting (used for uniqueness)"
  end

  newparam(:service) do
    isrequired
    desc "the name of the service to be changed

This refers to the 'service name' in the master(5) manpage and its value depends on the value specified for the type of the service."
  end

  newproperty(:type) do
    isrequired
    desc "the type of the service to be managed

This refers to the 'service type' in the master(5) manpage."
    newvalues(:inet, :unix, :fifo, :pass)
  end

  newproperty(:private) do
    desc "Whether or not access is restricted to the mail system."
    defaultto { '-' }
    newvalues(:true, :false)
  end

  newproperty(:unprivileged) do
    desc "Whether the service runs with root privileges or as the owner of the Postfix mail system"
    defaultto { '-' }
    newvalues(:true, :false)
  end

  newproperty(:chroot) do
    desc "Whether or not the service runs chrooted to the mail queue directory"
    defaultto { '-' }
    newvalues(:true, :false)
  end

  newproperty(:wakeup) do
    desc "Automatically wake up the named service after the specified num of seconds."
    defaultto { '-' }
  end

  newproperty(:proces_limit) do
    desc "The maximum number of processes that may execute this service"
    defaultto { '-' }
  end

  newproperty(:command) do
    desc "The command to be executed."
    isrequired
    defaultto { '-' }
  end

  newproperty(:instance) do
    desc "the instance to which the configuration setting belongs"
    defaultto { nil }
  end
   
  autorequire(:postfix_instance) do
    self[:instance]
  end
end
