#!/usr/bin/env perl

# 
# The following script expects as first argument a `delimiter`

use strict;
use warnings;
use v5.014;


my $delim = shift @ARGV;

my @progs;
my $acc = '';

while (my $part = shift @ARGV) {
  chomp $part;

  if ($part =~ /^$delim$/) {
    if ($acc ne '') {
      push @progs, $acc;
    }

    $acc = '';
    next;
  }

  $acc .= $part . ' ';
}

my $sequence = join '| ', @progs;
my $resp = `$sequence`;
say $resp;
