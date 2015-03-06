#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

MAIN:
{
	if (@ARGV != 1 || $ARGV[0] !~ /^[1-9][0-9]*$/) {
		die("Usage: dragon generation\n\nThe generation must be a positive integer.\n");
	}
	my $generation = $ARGV[0];

	my @turns = (1);
	for my $gen (2..$generation) {
		@turns = (@turns, 1, map { 1 - $_ } reverse @turns);
	}

	say @turns;
}
