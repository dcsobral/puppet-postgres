class postgres::base {
    file { 'pg_hba':
        mode         => 644,
        owner        => 'postgres',
        group        => 'postgres',
        sourceselect => all,
        source       => [
            'puppet:///files/warning.txt',
            'puppet:///postgres/warning.txt',
        ],
        require      => [
            User['postgres'],
            Group['postgres'],
        ],
    }

    group { 'postgres': ensure  => present, }

    user { 'postgres':
        ensure  => present,
        gid     => postgres,
        require => Group['postgres'],
    }

    service { 'postgresql':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => User['postgres'],
    }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
