#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: cntfiles.pl
#
#        USAGE: ./cntfiles.pl  
#
#  DESCRIPTION: count files with open
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 11:19:31 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

# read directly from the DATA section

say while <DATA>;

say '-' x 25;

# a simple example reading cyrillic text

open CYR, 'cyr-utf8.txt' or die $!;
chomp and print while <CYR>;
close CYR;

say and say '-' x 25;

# a directory listing using 'ls' and pipe
#

open LS, '|ls' or die $!;
say while <LS>;

# a directory listing using <*>

say while <*>;


__DATA__

this is intermediate container
