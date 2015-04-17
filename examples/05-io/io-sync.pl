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

use Set::Functional qw/difference_by/;
use File::Copy qw/copy/;

use v5.012;

use experimental qw/switch autoderef/;

# I assume both these exist 
my @q = ( '/home/stelf/tmp/s', '/home/stelf/tmp/d');

# queue of directories I would like to walk
# while there are more directories in the queue

while (@q)  { 
    my ( $src, $dst ) = (shift @q, shift @q);
    say 'entering: ', $src, ' and ', $dst; 
    
    my @dlist;
    my @slist = <$src/*>;

    # take one, and read it's contents
    foreach my $entry (@slist) {
        my $fname = substr $entry, length($src) + 1;

        my $sfile = $src.'/'.$fname;
        my $dfile = $dst.'/'.$fname;

        # check if directory of file
        given ($entry) { 
            when (-f) { 
                say 'sync: ', $sfile;
                # get sizes of files
                my ($ssize, $dsize) = 
                    (stat $sfile)[7],
                    (stat $dfile)[7];
                
                    copy $sfile, $dfile 
                        unless defined $dsize and $ssize == $dsize;
            }

            when (-d) { 
                say 'schedule: ', $sfile;

                unless  (/^\./) { 
                    # this is a directory
                    push @q, ($sfile, $dfile);

                    # if the destination dir does not exist - create it
                    -e $dst.'/'.$fname or mkdir $dst.'/'.$fname;
                }
            }
        }
    }

    # not optimal but, works...
    @slist = map { [ substr ($_, length($src) + 1), $_ ] } <$src/*>;
    @dlist = map { [ substr ($_, length($dst) + 1), $_ ] } <$dst/*>;
    
    foreach my $dfile ( difference_by { $_->[0] } [@dlist], [@slist] ) {
        say 'removing: ', $dfile->[1];
        -f $dfile->[1] and unlink $dfile->[1] ;
    }
}



