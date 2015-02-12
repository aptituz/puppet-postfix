# = Define: postfix::config
#
# Handle a postfix configuration file
define postfix::config (
    $path       = $title,
    $ensure     = 'present',
    $template   = $postfix::params::config_template,
    $source     = undef,
    $options    = undef,
) {
    
    if $source {
        $real_content   = undef
        $real_source    = $source
    } else {
        $real_content   = template($template)
        $real_source    = undef
    }

    file { $path:
        ensure  => $ensure,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $real_content,
        source  => $real_source,
        notify  => Service['postfix']
    }

}
