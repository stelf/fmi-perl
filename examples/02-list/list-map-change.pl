#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: list-map-change.pl
#
#        USAGE: list-map-change.pl
#
#  DESCRIPTION: demonstrate the effect of map aligning $_ with array elements
#
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 12:58:30 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

my @ary = (1,2,4,5);

# please note that map can acually change 
# and $_ is aligned i.e. references each 
# element of @ary and thus is iterator

say join ',', map { $_ *= 2 } @ary;
say "@ary";

