#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: regexp-backref.pl
#
#        USAGE: ./regexp-backref.pl  
#
#  DESCRIPTION: bakcref
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 24.03.2015 г. 20:25:04 ч.
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

open INPUT, '../../var/regexp-backref-INPUT.txt' or die $!;

while (<INPUT>) {
    / (.*?) \s ((.*? (\1) )+) /x;
    say "[$1] is contained within [$2] at least once";
    say "these are : ", join ',', $2 =~ /\Q$1\E/g;
}

close INPUT
