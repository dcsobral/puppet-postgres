/*
== Definition: postgres::hba

Add/remove lines from pg_hba.conf file. NB: puppet reloads postgresql each time
a change is made to pg_hba.conf using this definition.

Parameters:
- *ensure*: present/absent, default to present.
- *type*: local/host/hostssl/hostnossl, mandatory.
- *database*: database name or "all", mandatory.
- *user*: username or "all", mandatory.
- *address*: CIDR or IP-address, mandatory if type is host/hostssl/hostnossl.
- *method*: auth-method, mandatory.
- *option*: optional additional auth-method parameter.

See also:
http://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html

Example usage:

    postgres::hba { "access to database toto":
        ensure     => present,
        type         => 'local',
        database => 'toto',
        user         => 'all',
        method     => 'ident',
        option     => "map=toto",
    }

    postgres::hba { "access to database tata":
        ensure     => present,
        type         => 'hostssl',
        database => 'tata',
        user         => 'www-data',
        address    => '192.168.0.0/16',
        method     => 'md5',
    }

*/
define postgres::hba ($ensure='present', $type, $database, $user, $address=false, $method, $option=false)
{
    include postgres
    include postgres::augeas::hba

    if $augeasversion {
        case $type {
            'local': {
                $changes = [ # warning: order matters !
                    "set pg_hba.conf/1/type ${type}",
                    "set pg_hba.conf/1/database ${database}",
                    "set pg_hba.conf/1/user ${user}",
                    "set pg_hba.conf/1/method ${method}",
                ]
    
                $xpath = "pg_hba.conf/*[type='${type}'][database='${database}'][user='${user}'][method='${method}']"
            }
    
            'host', 'hostssl', 'hostnossl': {
                if ! $address {
                    fail("\$address parameter is mandatory for non-local hosts.")
                }
    
                $changes = [ # warning: order matters !
                    "set pg_hba.conf/1/type ${type}",
                    "set pg_hba.conf/1/database ${database}",
                    "set pg_hba.conf/1/user ${user}",
                    "set pg_hba.conf/1/address ${address}",
                    "set pg_hba.conf/1/method ${method}",
                ]
    
                $xpath = "pg_hba.conf/*[type='${type}'][database='${database}'][user='${user}'][address='${address}'][method='${method}']"
            }
    
            default: {
                fail("Unknown type '${type}'.")
            }
        }
    
        if versioncmp($augeasversion, '0.7.3') < 0 {
            $lpath = "/usr/share/augeas/lenses/contrib/"
        } else {
            $lpath = undef
        }
    
        case $ensure {
            'present': {
                augeas { "set pg_hba ${name}":
                    context => "/files/etc/postgresql/${pgversion}/main/",
                    changes => $changes,
                    onlyif    => "match ${xpath} size == 0",
                    notify    => Service["postgresql"],
                    require => [Package["postgresql-${pgversion}"], File["/usr/share/augeas/lenses/contrib/pg_hba.aug"]],
                    load_path => $lpath,
                }
    
                if $option {
                    augeas { "add option to pg_hba ${name}":
                        context => "/files/etc/postgresql/${pgversion}/main/",
                        changes => "set ${xpath}/method/option ${option}",
                        onlyif    => "match ${xpath}/method/option size == 0",
                        notify    => Service["postgresql"],
                        require => [Augeas["set pg_hba ${name}"], File["/usr/share/augeas/lenses/contrib/pg_hba.aug"]],
                        load_path => $lpath,
                    }
                }
            }
    
            'absent': {
                augeas { "remove pg_hba ${name}":
                    context => "/files/etc/postgresql/${pgversion}/main/",
                    changes => "rm ${xpath}",
                    #onlyif    => "match ${xpath} size == 1",
                    notify    => Service["postgresql"],
                    require => [Package["postgresql-${pgversion}"], File["/usr/share/augeas/lenses/contrib/pg_hba.aug"]],
                    load_path => $lpath,
                }
            }
    
            default: {
                fail("Unknown ensure '${ensure}'.")
            }
        }
    }
}

