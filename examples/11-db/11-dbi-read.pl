#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: 11-dbi-first.pl
#
#        USAGE: ./11-dbi-first.pl  
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
#      CREATED: 04/24/2015 12:09:42 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

use DBI;

my $dbfile = 'mydata.bin';

my $dbh = DBI->connect("dbi:CSV:","","", {
    f_dir => "data",
    f_ext => ".csv/r",
});

my $sth = $dbh->prepare('SELECT * FROM test');
$sth->execute;

while (my $data =  $sth->fetchrow_arrayref ) {  
    local $, = ' | ';
    say @$data;
}

