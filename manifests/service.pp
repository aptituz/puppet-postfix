# = Class: postfix::service
#
# Manage the postfix service
class postfix::service (
    $ensure         = 'running',
    $enabled        = true,
    $service_name   = $postfix::params::service_name,
) {

    Class['postfix::package'] -> Class['postfix::service']

    if $ensure == 'ignore' {
      $real_ensure = undef
    } else {
      $real_ensure = $ensure
    }

    service { $service_name:
        ensure     => $real_ensure,
        enable     => $enabled,
        hasrestart => true,
        restart    => 'service postfix reload',
        hasstatus  => true,
        require    => Package['postfix'],
    }
}
