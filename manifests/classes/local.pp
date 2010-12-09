class postgres::local inherits postgres {
    postgres::pg_hba { "local": }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
