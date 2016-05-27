#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


#
# Generating high load
my $n = 8;
for (1..$n) {
  my $pid = fork;
  if (!$pid) {
    my $i = 0;
    while ($i < 10_000_000) {
      my $x = rand;
      my $y = rand;
      my $z = $x + $y;
      $i++;
    }
    exit;
  }
}

for (1..$n) {
  wait();
}
