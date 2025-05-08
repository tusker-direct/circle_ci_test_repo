package MyApp::Cars;
use strict;
use warnings;
use DBI;
use DBD::MariaDB;
use Carp 'croak';

sub new {
	my $class = shift;
	my ($dbh) = @_;

	my $self = {
		dbh => $dbh,
	};

	return bless $self, $class;
}

sub all_cars {
	my $self = shift;

	my $sth = $self->{dbh}->prepare("SELECT * FROM cars");
	$sth->execute();

	return $sth->fetchall_arrayref();
}


1; 