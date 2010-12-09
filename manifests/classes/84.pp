class postgres::84 inherits postgres::base {
    package { 'postgresql-8.4':
        ensure => installed,
        before => [
            User['postgres'],
            Group['postgres'],
            Service['postgresql'],
        ],
    }

    File ['pg_hba'] { path => '/etc/postgresql/8.4/main/pg_hba.conf' }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
