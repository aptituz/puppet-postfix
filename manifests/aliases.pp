# = Class: postfix::aliases
#
# Handles the /etc/aliases
class postfix::aliases (
    $ensure     = 'present',
    $template   = 'postfix/aliases.erb',
    $source     = undef
) {
    include postfix::newaliases

    if $source {
        $real_content = undef
        $real_source  = $source
    } else {
        $real_content = template($template)
        $real_source  = undef
    }

    file { '/etc/aliases':
        ensure  => $ensure,
        content => $real_content,
        source  => $real_source,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Exec['newaliases'],
        require => Package['postfix'],
    }
}
