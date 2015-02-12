# = Class: postfix::package
#
# Manage the postfix package(s)
#
class postfix::package (
    $ensure = 'present',
    ) {

    package { 'postfix':
        ensure => $ensure,
    }
}
