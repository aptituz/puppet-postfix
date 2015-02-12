# = Class: postfix::ldap
#
# Enable support for pcre maps
class postfix::pcre {
    if $osfamily == 'Debian' {
        package { 'postfix-pcre':
            ensure  => present
        }
    }
}
