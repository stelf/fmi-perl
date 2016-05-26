#!/usr/bin/env perl

use threads;

use strict;
use warnings;
use v5.014;


#
# Spawning 10 printing threads
say "SPAWNING THREADS";

sub printing_thread {
  my $n = shift;
  sleep 1;
  say "\tI print stuff $n";
}

my @threads;
for my $i (1..10) {
  my $thr = threads->create('printing_thread', $i);
  push @threads, $thr;
}

say "-- Threads created";
say "-- running: " . threads->list(threads::running);
say "-- joinable: " . threads->list(threads::joinable);

for my $t (@threads) {
  $t->join();
  say "-- Joined " . $t->tid();
}

say "-- Threads joined";

#
# Using async 
say "\nCOMMANDING THREADS";

my @workers;

while (<STDIN>) {
  chomp;

  if (/hello/) { 
    push @workers, async { return do_hello() }; 
  } elsif (/goodbye/) {
    push @workers, async { return do_goodbye() }; 
  }
}

sub do_hello {
  sleep 2;
  say "hello there!";
}

# The last one won't get joined
sub do_goodbye {
  for my $w (@workers) {
    $w->join();
  }
  say "bye.";
  exit 0;
}
