class postgres::samenet inherits postgres {
    postgres::pg_hba { "samenet": }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
