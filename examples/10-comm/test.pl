#!/usr/bin/perl

use v5.12;
use strict;
use warnings;

use Test::Comm qw/comm_init/;

my $comm = comm_init();
say keys %{$comm};
