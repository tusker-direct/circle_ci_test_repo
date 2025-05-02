use Mojo::Base -strict;

use lib "lib";
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('MyApp');
$t->get_ok('http://127.0.0.1:3000')->status_is(200)->content_like(qr/Mojolicious/i);

done_testing();
