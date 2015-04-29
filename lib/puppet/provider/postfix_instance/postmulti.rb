require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "puppet_x", "aptituz", "postfix.rb"))

Puppet::Type.type(:postfix_instance).provide(:postmulti) do

  commands :postmulti => 'postmulti'
  commands :postconf  => 'postconf'

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
     Puppetx::Aptituz::Postfix.get_postfix_instances.collect do |name, instance|
        new(  :name              => name,
              :ensure            => :present,
              :group             => instance[:group],
              :enabled           => instance[:enabled],
              :config_directory  => instance[:config_directory],
              :queue_directory   => instance[:queue_directory],
              :data_directory    => instance[:data_directory],
        )
     end
  end

  def self.prefetch(resources)
    postfix_instances = Hash[self.instances.map{|i| [i.name, i]}]
    resources.each do |name,resource|
      if prov = postfix_instances[name]
        resources[name].provider = prov
      end
    end
  end

  mk_resource_methods

  def enabled=(value)
    @property_flush[:enabled] = value
  end

  def config_directory=(value)
    raise Puppet::Error,
      "changing the config_directory of an existing postfix_instance is not supported"
  end

  def queue_directory=(value)
    @property_flush[:queue_directory] = value
  end

  def spool_directory=(value)
    @property_flush[:spool_directory] = value
  end

  def data_directory=(value)
    @property_flush[:data_directory] = value
  end

  def group=(group)
    @property_flush[:group] = group
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    cmd = 'create'
    args = [ "config_directory=#{resource[:config_directory]}" ]
    if Dir.exists?(@resource[:config_directory])
      cmd = 'import'
    else
      args.push("queue_directory=#{resource[:queue_directory]}",
                "data_directory=#{resource[:data_directory]}")
    end

    params = [ '-e', cmd, '-I', self.name ]
    if ! @resource[:group].nil?
        params.push('-G', @resource[:group])
    end

    [:enabled, :queue_directory, :data_directory].each do |k|
      if not @resource[k].nil?
        @property_flush[k] = @resource[k]
      end
    end

    begin
      cmd = ['postmulti', params, args].join(" ")
      debug("Executing '#{cmd}'")
      stdout_str, stderr_str, status =
        Open3.capture3(cmd)
        debug(stdout_str)
    rescue SystemCallError => e
      raise Puppet::Error, "Could not run postmulti #{self.name}: #{stderr_str}", $!.backtrace
      return nil
    end

    if status.success?
      @property_hash[:ensure] = :present
    else
      raise Puppet::Error, "Failed to add or import instance #{self.name}: #{stdout_str}"
    end
  end

  def destroy
    postmulti( '-x', 'postfix', 'stop', '-i', @resource[:name])
    postmulti( '-e', 'disable', '-i', @resource[:name])
    postmulti( '-e', 'destroy', '-i', @resource[:name])
  end

  def flush
    debug("Flushing postfix_instance #{self.name}")

    instance_settings = {}
    if @property_flush[:group]
      postmulti('-e', 'assign', '-i', self.name, '-G', @property_flush[:group])
    end

    if @property_flush[:enabled]
      instance_settings['multi_instance_enable'] =
        (@property_flush[:enabled]) ? 'yes' : 'no'
    end

    if @property_flush[:queue_directory]
      instance_settings['queue_directory'] = @property_flush[:queue_directory]
    end

    if @property_flush[:data_directory]
      instance_settings['data_directory'] = @property_flush[:data_directory]
    end

    unless instance_settings.empty?
        Puppetx::Aptituz::Postfix.set_postconf_values(self.name, instance_settings)
    end

  end
end

