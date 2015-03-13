#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: closure.pl
#
#        USAGE: ./closure.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 01:06:36 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.012;


sub a {
    my $pyram = shift;

    sub { 
        my $param = shift;
        say "param is $param, and pyram is $pyram";
    }
}

my $res = a("curry me please");;
&{$res}(20);        # dereference


