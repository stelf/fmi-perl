#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


#
# Spawning many children
say "Process ID $$";


my $n = 3;
my $forks = 0;
for (1..$n) {
  my $pid = fork;
  if (!defined $pid) {
    warn "Unable to fork";
    next;
  }

  if ($pid) {
    $forks++;
    say "In parent PID ($$), Child PID ($pid), forks ($forks)";
  } else {
    say "In child PID ($$)";
    sleep 2;
    say "Child ($$) exiting";
    exit
  }
}

for (1..$forks) {
  my $pid = wait();
  say "Child ($pid) exited";
}
say "Parent ($$) ending";
