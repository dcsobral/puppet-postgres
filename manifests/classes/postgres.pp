class postgres {
    if $pgversion == "" {
        exec { '/bin/false # missing postgres version': }
    } else {
        $pgdata = "/etc/postgresql/$pgversion/main"

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
