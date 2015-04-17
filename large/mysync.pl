#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: mysync.pl
#
#        USAGE: ./mysync.pl  
#
#  DESCRIPTION: sync two dirs while traversing them
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: stelf
# ORGANIZATION: Practical Perl Programming at @FMI
#      VERSION: 1.0
#      CREATED: 04/17/2015 10:26:10 AM
#===============================================================================

use strict;
use warnings;
use utf8;

use File::Copy qw/copy/;

use v5.012;

use experimental qw/switch autoderef/;

# I assume both these exist 
my @q = ( '/tmp/s', '/tmp/d');

# queue of directories I would like to walk

# while there are more directories in the queue
while (@q)  { 
    my ( $src, $dst ) = (shift @q, shift @q);
    say 'entering: ', $src, ' and ', $dst; 

    # take one, and read it's contents
    foreach my $entry (<$src/*>) {
        my $fname = substr $entry, length($src) + 1;
        # check if directory of file
        given ($entry) { 
            when (-f) { 
                $DB::single = 1;
                # get sizes of files
                my ($ssize, $dsize) = 
                    (stat($src.'/'.$fname))[7],
                    (stat($dst.'/'.$fname))[7];
                
                if ( $ssize != $dsize ) { 
                    copy $src.'/'.$fname, $dst.'/'.$fname;
                }
            };

            when (-d) { 
                unless  (/^\./) { 
                    # this is a directory
                    push @q, $src.'/'.$fname;
                    push @q, $dst.'/'.$fname;

                    # if the destination dir does not exist - create it
                    unless( -e $dst.'/'.$fname ) {
                        mkdir $dst.'/'.$fname;
                    }
                }
            }
        }
    }
}



