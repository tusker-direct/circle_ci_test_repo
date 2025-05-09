#!/usr/bin/env perl

package basic;
use Mojo::Base -strict;

use lib "lib";
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('MyApp');

$t->get_ok('/')->status_is(200);

my $response = $t->tx->res->json;

is($response->{id},    1,        'ID is 1');
is($response->{make},  'Dacia',  'Make is Dacia');
is($response->{model}, 'Duster', 'model is Duster');
is($response->{year},  2010,     'Year is 2010');

done_testing();

