#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use lib './lib';
use PPP::Abook qw/add_address remove_address list/;


my %cmds = (
  add => \&add_address,
  remove => \&remove_address,
  list => \&list
);

sub handle_cmd {
  my $cmd = shift;

  my ($op, @args) = @$cmd;

  $cmds{$op}->(@args);
}


handle_cmd(
  [@ARGV]
);
