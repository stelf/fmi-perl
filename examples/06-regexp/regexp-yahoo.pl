#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: regexp-yahoo.pl
#
#        USAGE: ./regexp-yahoo.pl  
#
#  DESCRIPTION: find the results from yahoo
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/27/2015 10:53:16 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

# please note that matching stuff in HTML is generally a bad idea
# you should use a HTML parsing module, and XPATH queries or
# REST where possible

use List::Util qw/pairmap/;
use LWP::Simple qw/get/;

my $mrx = qr!<a.*?class=" td-u".*?href="(.*?)".*?>(.*?)</a>!;
my $res = get q#http://search.yahoo.com/search?p=first+amendment&fr=sfp&fr2=sb-top-search#;

say pairmap {
    $b =~ s/<.*?>//g;                           # clear tags
    ( "title :", $b, "\n", "url: ", $a, "\n");  # prepare res
} $res =~ /$mrx/g;


