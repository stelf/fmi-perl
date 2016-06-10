#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use AnyEvent;

$| = 1; # Show the meaning of this
print "enter your name> ";

my $name;

my $name_ready = AnyEvent->condvar;

my $wait_for_input = AnyEvent->io(
  fh => \*STDIN,
  poll => "r",
  cb => sub {
    $name = <STDIN>;
    $name_ready->send;
  }
);

$name_ready->recv;

undef $wait_for_input;

print "your name is $name\n";
