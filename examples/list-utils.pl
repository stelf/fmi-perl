#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: reduce.pl
#
#        USAGE: ./reduce.pl  
#
#  DESCRIPTION: reduce example
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME ()  
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 12:33:11 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use List::Util qw/reduce any all pairgrep/;

use v5.012;

my @ary = qw/ 1 2 5 6 7 8 6 5 4 3 /;

say reduce { $a + $b } @ary;
say 'some elements are greater than 10 ' if any { $_ > 5 } @ary;
say 'all elements are positive' if all { $_ > 0 } @ary;

any { $_ & 1 } @ary and say 'some elements are odd';

say join ',', pairgrep { $a + $b < 10 } @ary;


