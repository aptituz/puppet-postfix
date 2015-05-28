# = Define: postfix::mapsupport
#
# Define to install loadable map support packages for postfix (e.g. optional ldap support)
define postfix::mapsupport (
    $ensure         = 'present',
    $map            = $title,
    $package        = undef,
) {

    if ! defined(Class['postfix']) {
        fail('You must include the postfix base class before using any postfix defined resources')
    }

    if $::osfamily == 'Debian' {
        if $package {
            $real_package = $package
        } else {
            $real_package = "postfix-${map}"
        }

        package { $real_package:
            ensure  => $ensure,
            notify  => Service['postfix'],
            require => Package['postfix']
        }

    } else {
        warn("no package known for ${map}-support on ${::osfamily}. If this is an error, please file a bug")
    }

}
    
