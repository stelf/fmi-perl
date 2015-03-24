#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: regexp-split-vs-match.pl
#
#        USAGE: ./regexp-split-vs-match.pl  
#
#  DESCRIPTION: split vs match example
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 24.03.2015 г. 20:08:04 ч.
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;


my $wstr = "one two three four !!!! something %^* else...";

local $, = ',';
say split /\W/, $wstr;
say split /\W+/, $wstr;

# say presumes list context
say $wstr =~ m/ \w+ /xg;

# basically the scheme
say split ' ', $wstr;
say $wstr =~ m/ \S+ /xg;

while ( $wstr =~ /(\w+)\s+(\w+)/g ) { 
    say $1, $2;   
};

