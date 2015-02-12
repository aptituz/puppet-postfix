# = Class: postfix::ldap
#
# Enable support for ldap maps
class postfix::ldap {
    if $osfamily == 'Debian' {
        package { 'postfix-ldap':
            ensure  => present
        }
    }
}
