# = Class: postfix::pgsql
#
# Enable support for pgsql maps
class postfix::pgsql {
    if $osfamily == 'Debian' {
        package { 'postfix-pgsql':
            ensure  => present
        }
    }
}
