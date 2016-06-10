#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use AnyEvent;

$| = 1;
print "enter your name";

my $name;

my $wait_for_input = AnyEvent->io(
  fh => \*STDIN,
  poll => "r",
  cb => sub {
    $name = <STDIN>;
  }
);
