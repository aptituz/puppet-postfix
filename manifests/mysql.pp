# = Class: postfix::mysql
#
# Enable support for mysql maps
class postfix::mysql {
    postfix::mapsupport { 'mysql': }
}
