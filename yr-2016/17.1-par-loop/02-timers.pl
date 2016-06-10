#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use AnyEvent;


my $cv = AnyEvent->condvar;

my $wait_one_and_a_half_secs = AnyEvent->timer(
  after => 1.5,
  cb => sub {
    $cv->send;
  }
);

$cv->recv;

print "1.5 secs passed\n";
