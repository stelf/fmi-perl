#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: list-comprehensions.pl
#
#  DESCRIPTION: array slice & list comprehensions
#
#       AUTHOR: stelf
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 10:56:13 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

my @ary = qw/a b c d e f g h/;

say "original: @ary";

# variant 1 - use list comprehension to get indices 
# in order ( 1, 0, 3, 2, 5, 4.... n+1, n)
# and then slice the array in this order

@ary = @ary[map {($_ + 1, $_)} map {$_*2} 0..@ary/2-1];

say "reversed: @ary";

# variant 2 - iterate with list
#
for my $i (grep { $_ & 1 } 1..@ary) { 
    @ary[$i-1, $i ] = @ary[$i, $i-1];
}

say "back again: @ary";

use List::Util qw/pairmap/;

@ary = pairmap { ($b, $a) } @ary; 

say "...and back: @ary";
