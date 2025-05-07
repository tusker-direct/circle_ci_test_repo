package MyApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {

	my $db = $self->db;

	# all cars
	my $cars = $db->all_cars;


	# Render template "example/welcome.html.ep" with message
	$self->render(msg => 'Welcome to the Mojolicious real-time web framework!', cars => $cars);
	return;
}

1;
