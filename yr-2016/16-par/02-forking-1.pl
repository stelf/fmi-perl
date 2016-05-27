#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


#
# Simple forking
say "PID $$";
my $pid = fork();
die if not defined$pid;
say "PID $$ ($pid)";
