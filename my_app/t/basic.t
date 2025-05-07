package basic;
use Mojo::Base -strict;

use lib "lib";
use Test::More;
use Test::Mojo;
use File::Temp qw(tempfile);
use MyApp::Database;

# Set test database environment variables
$ENV{DB_HOST} = 'localhost';
$ENV{DB_NAME} = 'myapp_test';
$ENV{DB_USER} = 'myapp';
$ENV{DB_PASSWORD} = 'myapppass';
$ENV{DB_PORT} = '5433';

my $t = Test::Mojo->new('MyApp');
$t->get_ok('http://127.0.0.1:3000')->status_is(200)->content_like(qr/Mojolicious/i);

# Create a temporary database file for testing
my (undef, $db_file) = tempfile();
my $db = MyApp::Database->new($db_file);

# Test adding a user
my $user_id = $db->add_user('test_user', 'test@example.com');
ok($user_id, 'User was added successfully');

# Test retrieving a user
my $user = $db->get_user($user_id);
is($user->{username}, 'test_user', 'Username matches');
is($user->{email}, 'test@example.com', 'Email matches');

done_testing();
1;
