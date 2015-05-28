# = Define:: postfix::map
define postfix::map (
    $path     = $title,
    $confdir  = $postfix::params::confdir,
    $ensure   = 'present',
    $source   = undef,
    $content  = undef,
) {

    if ! defined(Class['postfix']) {
        fail('You must include the postfix base class before using any postfix defined resources')
    }

    if $path =~ /\// {
        $real_path = $path
    } else {
        $real_path = "${confdir}/${path}"
    }

    file { $real_path:
        ensure  => $ensure,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['postfix'],
        notify  => Exec["postmap ${real_path}"],
    }

    # If the main.cf is handled via puppet, make sure that postmap command
    # is executed after main.cf was created (because otherwise it fails)
    if defined(Postfix::Config['/etc/postfix/main.cf']) {
        Exec <| title == "postmap ${real_path}" |> {
            require +> Postfix::Config['/etc/postfix/main.cf']
        }
    }

    exec { "postmap ${real_path}":
        command     => "/usr/sbin/postmap ${real_path}",
        refreshonly => true,
        require     => Package['postfix'],
    }

}
    
