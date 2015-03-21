# = Define: postfix::config
#
# Handle a postfix configuration file


define postfix::config (
    $path       = $title,
    $ensure     = 'present',
    $template   = undef,
    $source     = undef,
    $options    = undef,
) {

    if ! defined(Class['postfix']) {
        fail('You must include the postfix base class before using any postfix defined resources')
    }

    if ! $source and ! $content and ! $options {
        fail("You must either specify a source, content or pass options for a template ($title)")
    }
   
    $dir = dirname($path)
    if $dir and ! defined(File[$dir]) {
        file {$dir:
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
        }
    }

    if $source {
        $real_content   = undef
        $real_source    = $source
    } elsif $content {
        $real_content   = $content
        $real_source    = undef
    } else {

        if $template {
            $real_template = $template
        } elsif $path =~ /master.cf$/ {
            $real_template = "postfix/postfix_master.cf.erb"
        } elsif $path =~ /main.cf$/ {
            $real_template = "postfix/postfix_main.cf.erb"
        } else {
            fail("no template known for '$path' and none specified as parameter")
        }

        $real_content   = template($real_template)
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
        require => File[$dir]
    }

}
