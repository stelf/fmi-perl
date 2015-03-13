#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: wtf.pl
#
#        USAGE: ./wtf.pl  
#
#  DESCRIPTION: wtf?!
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
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

