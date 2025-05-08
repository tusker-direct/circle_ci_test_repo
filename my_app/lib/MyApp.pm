package MyApp;
use Mojo::Base 'Mojolicious', -signatures;
use Data::Dumper;
use DBI;

# This method will run once at server start
sub startup ($self) {
	# Load configuration from config file
	my $config = $self->plugin('NotYAMLConfig');

# Configure the application
	$self->secrets($config->{secrets});

# Initialize database and add helper
	$self->helper(db => sub {
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
		return $dbh;
	});

# Router
	my $r = $self->routes;

# Normal route to controller
	$r->get('/')->to('Example#welcome');


	return;
}

1;
