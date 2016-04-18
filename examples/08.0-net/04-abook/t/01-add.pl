#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use lib '../lib';
use PPP::Abook qw/add_address/;

use Test::More;


# Remove the CSV
add_address('pesho', '0883 8989 89');

open my $ab, '<', 'abook.csv'
  or die "Cannot open file: $!";

my $fst = <$ab>;

ok ($fst eq "pesho,0883 8989 89\n", 
  "Tests whether pesho was added");

done_testing();
