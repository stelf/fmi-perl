#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: foo.pl
#
#        USAGE: ./foo.pl  
#
#  DESCRIPTION: G
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 04/21/2015 01:08:43 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;
use lib '.';

use Polygon;
use Point;

my @t = (
    points => [ 
        {
            x => 0,
            y => 0,
        },
        {
            x => 0.0, 
            y => 10.0,
        },
        {
            x => 10, 
            y => 10,
        },
        {
            x => 10, 
            y => 0,
        }
]);

# YAAAY!@!! -> 40

use Benchmark qw/timethis/;

timethis 1000, sub {
    Polygon->new(@t)->perim;
};

