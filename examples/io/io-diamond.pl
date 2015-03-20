#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: io-diamond.pl
#
#        USAGE: ./io-diamond.pl  
#
#  DESCRIPTION: diamond operator read
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 02:11:28 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;


while (<STDIN>) {
    chomp;

    next unless length;
    last if $_ =~ /exit/i;
    
    given ($_) { 
        say $_, ' is lowercase'  when lc eq $_;
        say $_, ' is uppercase'  when uc eq $_;
    }

}
