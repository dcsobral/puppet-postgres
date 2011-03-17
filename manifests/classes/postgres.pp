class postgres {
    if $pgversion == "" {
        exec { '/bin/false # missing postgres version': }
    } else {
        $pgdata = "/etc/postgresql/$pgversion/main"

        package { "postgresql-$pgversion":
            ensure => installed,
            alias  => 'postgres',
            notify => Exec['pg_dropcluster'],
            before => [
                User['postgres'],
                Group['postgres'],
                Service['postgresql'],
            ],
        }

        exec { "/usr/bin/pg_dropcluster --stop $pgversion main":
            refreshonly => true,
            notify      => Exec['pg_createcluster'],
            before      => Exec['pg_createcluster'],
            alias       => 'pg_dropcluster',
        }

        exec { "/usr/bin/pg_createcluster --locale en_US.UTF-8 --start $pgversion main && /bin/sleep 1":
            refreshonly => true,
            before      => Service['postgresql'],
            alias       => 'pg_createcluster',
        }

        user { 'postgres':
            ensure  => present,
            gid     => 'postgres',
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

        if $pgversion == '8.3' {
            $servicename = 'postgresql-8.3'
            $servicealias = 'postgresql'
        } else {
            $servicename = 'postgresql'
            $servicealias = undef
        }

        exec { "/etc/init.d/$servicename reload":
            refreshonly => true,
            require     => Service['postgresql'],
            alias       => 'postgres-reload',
        }

        service { $servicename:
            ensure     => running,
            enable     => true,
            hasstatus  => true,
            hasrestart => true,
            alias      => $servicealias,
            require    => [
                User['postgres'],
                Package['postgres'],
            ],
        }
    }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
