# = Class: postfix::package
#
# Manage the postfix package(s)
#
class postfix::package (
    $ensure         = 'present',
    $package_name   = $postfix::params::package_name
    ) {

    package { $package_name:
        ensure => $ensure,
    }
}
