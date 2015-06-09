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

my $dbfile = 'mydata.csv';
my $dbh = DBI->connect("dbi:CSV:","","", { 
    f_ext            => ".csv/r",
    f_dir            => "data",
});


$dbh->do(qq {  
    CREATE TABLE 
        test( id int, name text, isnasty REAL )
}) or die $dbh->errstr;

my @ppl = (
    [1, 'Penkov', 0.8 ],
    [2, 'Kerezov', 1],
    [3, 'Pentchev', 0],
    [4, 'Shahpazov', 0.5],
    [5, 'Shahpazov', undef]
);

foreach my $data (@ppl) {  
    $dbh->do(qq { 
        INSERT INTO test (id, name, isnasty ) 
        VALUES  (?, ?, ? )
    }, undef, @{$data}) or die $dbh->errstr; 
}




