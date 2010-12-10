define postgres::pg_hba() {
    File <| title == 'pg_hba' |> {
        source => [
            "puppet:///files/postgres/host/pg_jba.conf.$title.$fqdn",
            "puppet:///files/postgres/host/pg_jba.conf.$title.$hostname",
            "puppet:///files/postgres/env/pg_jba.conf.$title.$environment",
            "puppet:///files/postgres/pg_jba.conf.$title",
            "puppet:///modules/postgres/pg_hba.conf.$title",
        ],
    }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
