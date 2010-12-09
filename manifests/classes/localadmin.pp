class postgress::localadmin inherits postgres::base {
    File [ 'pg_hba' ] { source +> 'puppet:///postgres/pg_hba.conf.localadmin' }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
