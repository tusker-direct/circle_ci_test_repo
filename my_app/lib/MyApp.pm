package MyApp;
use Mojo::Base 'Mojolicious', -signatures;
use MyApp::Database;

# This method will run once at server start
sub startup ($self) {
	# Load configuration from config file
	my $config = $self->plugin('NotYAMLConfig');

# Configure the application
	$self->secrets($config->{secrets});

# Initialize database and add helper
	$self->helper(db => sub {
		state $db = MyApp::Database->new();
	});

# Router
	my $r = $self->routes;

# Normal route to controller
	$r->get('/')->to('Example#welcome');

# Example route using database
	$r->get('/user/:id' => sub {
		my $c = shift;
		my $user = $c->db->get_user($c->param('id'));
		$user ? $c->render(json => $user) 
			  : $c->render(json => {error => 'User not found'}, status => 404);
	});

# Car routes
	$r->get('/cars/:id' => sub ($c) {
		my $car = $c->db->get_car($c->param('id'));
		$car ? $c->render(json => $car)
			 : $c->render(json => {error => 'Car not found'}, status => 404);
	});

	$r->get('/users/:id/cars' => sub ($c) {
		my $cars = $c->db->get_user_cars($c->param('id'));
		$c->render(json => $cars);
	});

	return;
}

1;
