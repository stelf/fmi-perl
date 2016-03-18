#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


sub insertion_sort {
  my ($arr) = @_;

  for (my $j = 1; $j <= $#$arr; $j++) {
    my $i = $j - 1;
    my $key = $$arr[$j];

    while ($i >= 0 && $$arr[$i] > $key) {
      $$arr[$i+1] = $$arr[$i];

      $i--;
    }

    $$arr[$i+1] = $key;
  }
}

my @arr = (4, 1, 3, 6, 1, 10);
insertion_sort(\@arr);
  
$, = ' ';
say @arr;
