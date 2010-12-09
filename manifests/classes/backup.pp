class postgres::backup inherits postgres {
    postgres::::pg_hba { "backup": }
    file { "$PGDATA/backupuser":
        owner   => 'postgres',
        group   => 'postgres',
        mode    => 440,
        notify  => Exec['postgres-reload'],
        require => [
            User['postgres'],
            Group['postgres'],
        ],
    }

    file { "$PGDATA/backupserver":
        owner   => 'postgres',
        group   => 'postgres',
        mode    => 440,
        notify  => Exec['postgres-reload'],
        require => [
            User['postgres'],
            Group['postgres'],
        ],
    }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
