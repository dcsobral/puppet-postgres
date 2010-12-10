define postgres::pg_hba() {
    File <| title == 'pg_hba' |> {
        source => [
            "puppet:///files/postgres/host/pg_hba.conf.$title.$fqdn",
            "puppet:///files/postgres/host/pg_hba.conf.$title.$hostname",
            "puppet:///files/postgres/env/pg_hba.conf.$title.$environment",
            "puppet:///files/postgres/pg_hba.conf.$title",
            "puppet:///modules/postgres/pg_hba.conf.$title",
        ],
    }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
