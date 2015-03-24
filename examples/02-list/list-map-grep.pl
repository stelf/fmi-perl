#!/usr/bin/perl

#===============================================================================
#
#         FILE: list-map-grep.pl
#
#  DESCRIPTION: count words with more than 3 character and print stats
#
#       AUTHOR: stelf
# ORGANIZATION: Practical Perl Programing at FMI/Sofia University
#      VERSION: 1.0
#
#===============================================================================


while (<>) {
    $words{$_} ++
        for ( grep { length > 3 } split /[^a-zA-Z]+/ )
}

print
    map { ( $_, " = ", $words{$_}, "\n" ) }
        sort { $words{$a} <=> $words{$b} }
            keys %words;
