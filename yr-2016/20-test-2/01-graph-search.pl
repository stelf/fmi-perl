#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use Data::Dumper;
use List::MoreUtils qw/sort_by/; 


my %nodes;

say "Input number of nodes";
my $n = <STDIN>;
say "Input node coords";
for my $i (0..$n-1) {
  print "node $i: ";
  my $line = <STDIN>;
  chomp $line;
  my ($x, $y) = split / /, $line;
  $nodes{$i}->{coords} = [ $x, $y ];
  $nodes{$i}->{name} = $i;
}

say "Input edges; End by Ctrl-D";
while (my $line = <STDIN>) {
  chomp $line;
  my ($a, $b) = split / /, $line;
  push @{$nodes{$a}->{edges}}, $b;
  push @{$nodes{$b}->{edges}}, $a;
}

sub euclid_dist {
  my ($c1, $c2) = @_;

  return sqrt(($c1->[0] - $c2->[0])^2 + ($c1->[1] - $c2->[1])^2);
}

my @que = ($nodes{0});
while (scalar @que) {
  my $start = shift @que;
  for my $e (sort_by { euclid_dist($nodes{$_}->{coords}, $start->{coords}) } @{$start->{edges}}) {
    if (!exists $nodes{$e}->{visited}) {
      push @que, $nodes{$e};
      $nodes{$e}->{visited} = 1;
      $nodes{$e}->{parent} = $start->{name};
    }
  }
}

say Dumper(%nodes);
