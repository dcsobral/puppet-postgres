class postgress::local inherits postgres::localadmin {
    File [ 'pg_hba' ] { source +> 'puppet:///postgres/pg_hba.conf.local' }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
