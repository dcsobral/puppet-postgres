class postgres::83 inherits postgres::base {
    package { 'postgresql-8.3':
        ensure => installed,
        before => [
            User['postgres'],
            Group['postgres'],
            Service['postgresql'],
        ],
    }

    File ['pg_hba'] { path => '/etc/postgresql/8.3/main/pg_hba.conf' }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
