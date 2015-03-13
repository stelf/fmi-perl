#!/usr/bin/perl

use strict;

my @files = <*pl>, <*sh>;
my $first = (sort { $a <=> $b } map { (stat)[9] } @files)[0];
my ($date, $mon, $year) = (localtime $first)[3, 4, 5];

print join '/', $date, $mon + 1, $year + 1900;

