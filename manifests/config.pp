# = Define: postfix::config
#
# Handle a postfix configuration file


define postfix::config (
    $path       = $title,
    $ensure     = 'present',
    $template   = $postfix::config_template,
    $source     = undef,
    $options    = undef,
) {

    if ! defined(Class['postfix']) {
        fail('You must include the postfix base class before using any postfix defined resources')
    }

    if ! $source and ! $content and ! $options {
        fail('You must either specify a source, content or pass options for a template')
    }

    if $source {
        $real_content   = undef
        $real_source    = $source
    } elseif $content {
        $real_content   = $content
        $real_source    = undef
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
        notify  => Service['postfix'],
        require => Package['postfix']
    }

}
