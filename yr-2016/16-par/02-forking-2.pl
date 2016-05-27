#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


#
# Variables and waiting
my $name = 'Parent';

say "PID $$";
my $pid = fork();
die if not defined $pid;

if (!$pid) { # We're in child
  say "In child ($name) - PID $$ ($pid)";
  $name = 'Child';
  # sleep 10;
  say "In child ($name) - PID $$ ($pid)";
  exit;
}

say "In parent ($name) - PID $$ ($pid)";
$name = 'Still parent';
# sleep 10; # Make it big to show how the child becomes a zombie
say "In parent ($name) - PID $$ ($pid)";

my $finished = wait();
say "In parent ($name) - PID $$ finished ($finished)";
