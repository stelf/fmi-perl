#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


sub abc {
  my $var = 1;

  sub foo {
    local $var = 4;
    say $var;
  }

  foo();

  say $var;
}

abc;
