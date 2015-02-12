class postfix::newaliases {
        exec { 'newaliases':
            command     => '/usr/bin/newaliases',
            refreshonly => true
        }
}
