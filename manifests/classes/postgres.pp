class postgres {
    if $pgversion == "" {
        exec { '/bin/false # missing postgres version': }
    } else {
        $PGDATA = "/var/lib/postgresql/$pgversion/main"

        package { "postgresql-$pgversion":
            ensure => installed,
            alias  => 'postgres',
            before => [
                User['postgres'],
                Group['postgres'],
                Service['postgresql'],
            ],
        }

        user { 'postgres':
            ensure  => present,
            gid     => postgres,
            require => [
                Group['postgres'],
                Package['postgres'],
            ],
        }

        group { 'postgres':
            ensure  => present,
            require => Package['postgres'],
        }

        file { 'pg_hba':
            mode         => 644,
            owner        => 'postgres',
            group        => 'postgres',
            path         => "/etc/postgresql/$pgversion/main/pg_hba.conf",
            notify       => Exec['postgres-reload'],
            require      => [
                User['postgres'],
                Group['postgres'],
            ],
        }

        exec { '/etc/init.d/postgresql reload':
            refreshonly => true,
            require     => Service['postgresql'],
            alias       => 'postgres-reload',
        }

        service { 'postgresql':
            ensure     => running,
            enable     => true,
            hasstatus  => true,
            hasrestart => true,
            require    => [
                User['postgres'],
                Package['postgres'],
            ],
        }

        # lens included upstream since augeas 0.7.4
        if versioncmp($augeasversion, '0.7.3') < 0 { $lens = present }
        else { $lens = absent }

        file { "/usr/share/augeas/lenses/contrib/pg_hba.aug":
            ensure => $lens,
            mode   => 0644,
            owner  => "root",
            source => "puppet:///postgresql/pg_hba.aug",
        }
    }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
