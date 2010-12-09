class postgress::localident inherits postgres::localadmin {
    File [ 'pg_hba' ] {
        source  +> 'puppet:///postgres/pg_hba.conf.localident',
        require +> Service['identd'],
    }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
