# = Class: postfix::pcre
#
# Enable support for pcre maps
class postfix::pcre {
    postfix::mapsupport { 'pcre': }
}
