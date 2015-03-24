#!/usr/bin/perl

#===============================================================================
#
#         FILE: list-fs-print-sort.pl
#
#  DESCRIPTION: find files and sort them based on their last modified date
#
#       AUTHOR: stelf
# ORGANIZATION: Practical Perl Programing at FMI/Sofia University
#      VERSION: 1.0
#     
#===============================================================================
 

use strict;

my @files = <*pl>, <*sh>;
my $first = (sort { $a <=> $b } map { (stat)[9] } @files)[0];
my ($date, $mon, $year) = (localtime $first)[3, 4, 5];

print join '/', $date, $mon + 1, $year + 1900;

