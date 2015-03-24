#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: regexp-greedy.pl
#
#        USAGE: ./regexp-greedy.pl  
#
#  DESCRIPTION: greedyness example
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 24.03.2015 г. 19:45:18 ч.
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

my $t = "baaaaaba ";
$t =~ /ba*b/;
say $&;              # will match baaaaaab

my $r = "bba ";
$r =~ /ba*b/;
say $&;

my $q = 'babbbbbbaaaaaaaaaaaaTTTTTT';
$q =~ /^(.*)(ba)((b|a){4,})/;
say 'greedy groups: ', $1, ',', $2, ',', $3, ',', $4;

$q =~ /^(.*?)(ba)((b|a){4,})/;
say 'non-greedy groups: ', $1, ',', $2, ',', $3, ',', $4;

