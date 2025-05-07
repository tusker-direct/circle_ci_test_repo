package MyApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use MyApp::Cars;

# This action will render a template
sub welcome ($self) {

	my $db = $self->db;

	# all cars
	my $cars = MyApp::Cars->new($db);


	# Render template "example/welcome.html.ep" with message
	# $self->render(msg => 'Welcome to the Mojolicious real-time web framework!', cars => $cars);
	$self->render(json => $cars);
	return;
}

1;
