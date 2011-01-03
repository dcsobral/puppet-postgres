class postgres::remote inherits postgres {
    postgres::pg_hba { 'remote': }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
