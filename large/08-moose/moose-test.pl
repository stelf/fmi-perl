#!/usr/bin/env perl

use lib 'lib';
use Point;

my $var = Point->new;

for (1..10000) {
	$var->x(int rand);
	$var->y(int rand);

	my $v2 = Point->new;
}
