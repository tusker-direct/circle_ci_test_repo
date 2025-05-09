use DBI;

my $dsn = "DBI:MariaDB:database=$ENV{DB_NAME};host=$ENV{DB_HOST};port=$ENV{DB_PORT}";
my $dbh = DBI->connect(
	$dsn,
	$ENV{DB_USER},
	$ENV{DB_PASSWORD},
	{
		RaiseError => 1,
		AutoCommit => 1
	}
) or die "Can't connect to database: $DBI::errstr";

my @cars = ({
		brand => 'Dacia',
		model => '1',
		year  => 2001,
		price => 2000
	},
	{
		brand => 'Toyota',
		model => 'Aygo',
		year  => 2010,
		price => 4000
	}
);


my $q = "INSERT IGNORE INTO cars (make, model, year, price) VALUES (?, ?, ?, ?)";

foreach my $car (@cars) {
	$dbh->do($q, undef, $car->{brand}, $car->{model}, $car->{year}, $car->{price});
}

