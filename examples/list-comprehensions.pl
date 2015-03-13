#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: lcompr.pl
#
#        USAGE: ./lcompr.pl  
#
#  DESCRIPTION: array slice & list comprehensions
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 10:56:13 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

my @ary = qw/1 2 5 2 593 937 489127 4812 847 1238 64 87/;

@ary[map {($_, $_ + 1)} map {$_*2} 0..@ary/2-1] = 
    @ary[map {($_ + 1, $_)}  map {$_*2} 0..@ary/2-1 ];


say join ',', @ary;

for my $i (grep { $_ & 1 } 1..@ary) { 
    @ary[$i-1, $i ] = @ary[$i, $i-1];
}

say join ',', @ary;


