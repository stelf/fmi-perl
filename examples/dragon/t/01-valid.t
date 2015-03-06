#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use Test::More tests => 4;
use Test::Command;

stdout_is_eq('perl dragon.pl 1', "1\n");
stdout_is_eq('perl dragon.pl 4', "110110011100100\n");

# The -m mode command-line option
stdout_is_eq('perl dragon.pl -m turns 4', "110110011100100\n");
stdout_is_eq('perl dragon.pl -m turtle 2',
    "forward 10\nright 90\nforward 10\nright 90\nforward 10\nleft 90\nforward 10\n");
