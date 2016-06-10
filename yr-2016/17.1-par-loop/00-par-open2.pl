#!/usr/bin/env perl

# 
# The following script expects as first argument a `delimiter`

use strict;
use warnings;
use v5.014;

use IO::Handle;


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


pipe (my $parent_rdr, my $child_wtr);
pipe (my $child_rdr, my $parent_wtr);
$child_wtr->autoflush(1);
$parent_wtr->autoflush(1);

if (my $pid = fork()) {
  close $parent_rdr;
  close $parent_wtr;

  waitpid 
}
