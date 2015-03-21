# = Class: postfix::ldap
#
# Enable support for ldap maps
class postfix::ldap {
    postfix::mapsupport { 'ldap': }
}
