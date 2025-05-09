use strict;
use warnings;
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

my $db_cars_table =<<~'SQL';
CREATE TABLE IF NOT EXISTS cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SQL

$dbh->do($db_cars_table);


my @cars = ({ 
	brand => 'Dacia',
	model => 'Duster',
	year => 2010,
	price => 2000
},
{
	brand => 'Toyota',
	model => 'Aygo',
	year => 2010,
	price => 4000
});


my $q = "INSERT IGNORE INTO cars (make, model, year, price) VALUES (?, ?, ?, ?)";

foreach my $car (@cars) {
	$dbh->do($q, undef, $car->{brand}, $car->{model}, $car->{year}, $car->{price});
}


