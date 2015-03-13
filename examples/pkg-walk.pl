#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: main.pl
#
#        USAGE: ./main.pl  
#
#  DESCRIPTION: print the main namespace
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 12:09:12 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.012;

our $var = '100';

foreach ( sort keys %main:: ) { 
    say sprintf "%s \t = %s",
        $_, $main::{$_}
}
