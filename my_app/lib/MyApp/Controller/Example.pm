package MyApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {

	my $db = $self->db;

	my $sth = $db->prepare("SELECT * FROM cars");
	$sth->execute();

	my $cars = $sth->fetchrow_hashref();

	# Render template "example/welcome.html.ep" with message
	# $self->render(msg => 'Welcome to the Mojolicious real-time web framework!', cars => $cars);
	$self->render(json => $cars);
	return;
}

1;
