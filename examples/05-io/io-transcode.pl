#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: transcode.pl
#
#        USAGE: ./transcode.pl  
#
#  DESCRIPTION: transcode cyrrilic
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/14/2015 12:08:35 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

my %xlat = map { /(\w)\s+(\w+)/ } <DATA>;

open CYR, '<:encoding(utf8)', 'cyr-utf8.txt' or die $!;
 
while (<CYR>) {
     s/[а-я]/$xlat{$&}/eg;
     print;
}

# say map { s/(\w)/$xlat{$1}/eg; $_ } <CYR>;

# i - not case sensitive (insensitive)
# m - match as multiline
# s - match as single line
# o - optimze / compile
# x - do not treat whitespace as part of regexp
# e - execute
# g - global 
 
__DATA__

а a
б b
в v
г g
д d 
е e
ж zh
з z
и i
й j
к k
л l
м m
н n
о o
п p
р r
с s 
т t
у u 
ф f
х h
ц c
ч ch
ш sh
щ sht
ъ x
ь `
ю yu
я ya
