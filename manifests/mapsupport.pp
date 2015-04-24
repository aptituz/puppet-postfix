# = Define: postfix::mapsupport
#
# Define to install loadable map support packages for postfix (e.g. optional ldap support)
define postfix::mapsupport (
    $map            = $title,
    $package        = undef,
    $package_ensure = 'present',
) {

    if ! defined(Class['postfix']) {
        fail("You must include the postfix base class before using any postfix defined resources")
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
        warn("no package known for $mod-support on $::osfamily. If this is an error, please file a bug")
    }

}
    
