class postgres::augeas::hba {
    # lens included upstream since augeas 0.7.4
    if versioncmp($augeasversion, '0.7.3') < 0 { $lens = present }
    else { $lens = absent }

    file { "/usr/share/augeas/lenses/contrib/pg_hba.aug":
        ensure  => $lens,
        mode    => 0644,
        owner   => "root",
        source  => "puppet:///postgres/pg_hba.aug",
        require => Class['augeas'],
    }

    exec { '/bin/true # postgres::aug requires augeas': require => Exec['assert_augeas'] }
}

