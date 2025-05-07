use strict;
use warnings;
use Test::More;
use File::Temp qw(tempfile);
use MyApp::Database;

# Create a temporary database for testing
my (undef, $db_file) = tempfile();
my $db = MyApp::Database->new($db_file);

# Test adding a user first (we need a user_id for the cars)
my $user_id = $db->add_user('car_owner', 'owner@example.com');
ok($user_id, 'User was created successfully');

# Test adding a car
my $car_id = $db->add_car('Toyota', 'Supra', 2024, 55000.00, $user_id);
ok($car_id, 'Car was added successfully');

# Test retrieving a car
my $car = $db->get_car($car_id);
is($car->{make}, 'Toyota', 'Car make matches');
is($car->{model}, 'Supra', 'Car model matches');
is($car->{year}, 2024, 'Car year matches');
is($car->{price}, 55000.00, 'Car price matches');
is($car->{user_id}, $user_id, 'Car owner matches');

# Test getting all cars for a user
my $user_cars = $db->get_user_cars($user_id);
is(scalar @$user_cars, 1, 'User has one car');
is($user_cars->[0]->{make}, 'Toyota', 'User car make matches');

done_testing(); 