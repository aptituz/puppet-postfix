# = Class: postfix
#
# Module to manage postfix
#
# == Requirements:
#
# - This module makes use of the example42 functions in the puppi module
#   (https://github.com/credativ/puppet-example42lib)
#
# == Parameters:
#
# [*ensure*]
#   What state to ensure for the package. Accepts the same values
#   as the parameter of the same name for a package type.
#   Default: present
#   
# [*ensure_running*]
#   Whether to ensure running postfix or not. The special value 'ignore'
#   tells puppet not to manage the service status
#   Default: running
#
# [*ensure_enabled*]
#   Whether to ensure that postfix is started on boot or not.
#   Default: true
#
# [*config_source*]
#   Specify a configuration source for the configuration (main.cf). If this
#   is specified it is used instead of a template-generated configuration
#
# [*main_config_template*]
#   Define a template to be used for the main.cf (if manage config is true)
#
# [*master_config_template*]
#   Define a template to be used for the master.cf (if manage config is true)
#
# [*disabled_hosts*]
#   A list of hosts whose postfix will be disabled, if their
#   hostname matches a name in the list.
#
# [*manage_config*]
#   Whether to manage configuration of postfix at all. If this is set to false
#   no configuration files (main.cf, aliases, etc.) will be managed at all.
#
# [*manage_aliases*]
#   Whether to manage the aliases file. Note that this also creates an
#   alias for the root user, so root_alias should be set to a sensible value.
#
# [*manage_instances*]
#   Whether instances should be managed. Only useful in conjunction
#   with the instances parameter.
#   (Default: False)
#
# [*instances*]
#   A list of postfix instances that should be created (only useful in
#   conjunction with manage_instances)
#
# [*aliases*]
#   Allows further aliases to be defined.
#
# == Author:
#
#   Patrick Schoenfeld <patrick.schoenfeld@credativ.de
class postfix (
    $ensure             = $postfix::params::ensure,
    $ensure_running     = $postfix::params::ensure_running,
    $ensure_enabled     = $postfix::params::ensure_enabled,
    $manage_config      = $postfix::params::manage_config,
    $manage_instances   = $postfix::params::manage_instances,
    $manage_aliases     = $postfix::params::manage_aliases,
    $config_source      = $postfix::params::config_source,
    $config_template    = $postfix::params::config_template,
    $instances          = $postfix::params::instances,
    $aliases            = $postfix::params::aliases,
    $postfix_options    = $postfix::params::postfix_options,
    $master_options     = $postfix::params::master_options,
    $disabled_hosts     = $postfix::params::disabled_hosts,
    ) inherits postfix::params {

    class { 'postfix::package':
        ensure => $ensure,
    }

    class { 'postfix::instances':
        manage_instances => $manage_instances,
        instances        => $instances,
        require          => Class['postfix::package'],
        notify           => Class['postfix::service']
    }

    if $::hostname in $disabled_hosts {
        $real_running = 'stopped'
        $real_enabled = false
    } else {
        $real_running = $ensure_running
        $real_enabled = $ensure_enabled
    }

    class { 'postfix::service':
        ensure  => $real_running,
        enabled => $real_enabled,
    }

    if $manage_config {
        postfix::config { '/etc/postfix/main.cf':
            ensure   => $ensure,
            options  => $postfix_options,
            template => $main_config_template,
        }

        postfix::config { '/etc/postfix/master.cf':
            ensure   => $ensure,
            options  => $master_options,
            template => $master_config_template,
        }        

        if $manage_aliases {
            class { 'postfix::aliases':
                ensure  => $ensure,
                aliases => $aliases
            }
        }

    }


}
