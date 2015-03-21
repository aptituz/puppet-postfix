# = Class postfix::params

class postfix::params {
    $ensure                 = present
    $ensure_running         = true
    $ensure_enabled         = true
    $manage_instances       = false
    $manage_aliases         = false
    $confdir                = '/etc/postfix'
    $config_source          = undef
    $main_config_template   = undef
    $master_config_template = undef
    $instances              = undef
    $myorigin               = undef
    $smtp_bind_address      = undef
    $smtp_helo_name         = $::fqdn
    $root_alias             = undef
    $aliases                = []
    $disabled_hosts         = []
    $relayhost              = undef
    $inet_interfaces        = undef
    $localdomain            = undef
    $postfix_options        = undef
    $master_options         = undef

    $service_name           = 'postfix'
    $package_name           = 'postfix'
}
