define postfix::config (
    $path       = $title,
    $ensure     = 'present',
    $template   = "postfix/postfix_main.erb",
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
        content => $content,
        source  => $source,
        notify  => Service['postfix']
    }

}
