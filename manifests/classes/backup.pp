class postgress::backup inherits postgres::base {
    File [ 'pg_hba' ] { source +> 'puppet:///postgres/pg_hba.conf.backup' }
    file { 'backupuser': }
    file { 'backupserver': }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
