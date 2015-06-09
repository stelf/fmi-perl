#!/usr/bin/env perl

use Test::More tests => 3;

use FindBin;

use lib "$FindBin::Bin/../lib";
use Point;
use Try::Tiny;


my $p = Point->new;

is (ref $p, 'Point', 'instantiate object');

$p->x(10);

is ($p->x, 10, 'accessor x is working');

try {
	$p->x(10.5);
} catch  {
	is($p->x, 10, 'accessor is properly limited');
};


