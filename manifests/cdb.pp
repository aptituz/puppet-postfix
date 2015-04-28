# = Class: postfix::cdb
#
# Enable support for ldap maps
class postfix::cdb {
    postfix::mapsupport { 'cdb': }
}
