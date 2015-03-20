#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: wanta.pl
#
#        USAGE: ./wanta.pl  
#
#  DESCRIPTION: context of function call
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 12:21:11 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use Devel::StackTrace;

use v5.012;

# please note that the last evaluation in function is the value of 
# the return statement. thus return may be omitted 

sub whocallme {
    say Devel::StackTrace->new->as_string;


    wantarray 
        ? (qw/list context/)
        : "scalar context" 
}

say join ',', whocallme;    # join defaults to list context
say scalar whocallme;       # scalar ... enforces scalar context
say whocallme;              # say defaults to list context


