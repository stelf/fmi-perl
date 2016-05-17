#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


sub get_arrays {
  my ($a1, $a2) = @_;

  $a1->[1] = 444;
  $a2->[1] = 444;
}

my @arr1 = (1, 2, 3);
my @arr2 = (3, 4, 5);

$, = ' ';

get_arrays [@arr1], [@arr2];

say @arr1;
say @arr2;

get_arrays \@arr1, \@arr2;

say @arr1;
say @arr2;
