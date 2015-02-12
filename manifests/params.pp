# = Class postfix::params

class postfix::params {
    $ensure             = present
    $ensure_running     = true
    $ensure_enabled     = true
    $manage_instances   = false
    $manage_aliases     = false
    $confdir            = '/etc/postfix'
    $config_source      = undef
    $config_template    = 'postfix/postfix_main.erb'
    $instances          = undef
    $myorigin           = undef
    $smtp_bind_address  = undef
    $smtp_helo_name     = $::fqdn
    $root_alias         = undef
    $aliases            = []
    $disabled_hosts     = []
    $relayhost          = undef
    $inet_interfaces    = undef
    $localdomain        = undef

    $service_name = 'postfix'
    $package_name = 'postfix'
}
