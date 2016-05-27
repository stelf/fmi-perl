#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use Parallel::ForkManager;


my $n = 8;
my $pm = Parallel::ForkManager->new($n);

for (1..$n) {
  $pm->start and next;

  my $i = 0;
  while ($i < 10_000_000) {
    my $x = rand;
    my $y = rand;
    my $z = $x + $y;
    $i++;
  }

  $pm->finish;
}

$pm->wait_all_children;
