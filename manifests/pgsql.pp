# = Class: postfix::pgsql
#
# Enable support for pgsql maps
class postfix::pgsql {
    postfix::mapsupport { 'pgsql': }
}
