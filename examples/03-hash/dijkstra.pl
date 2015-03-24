#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: dijkstra.pl
#
#        USAGE: ./dijkstra.pl  
#
#  DESCRIPTION: Dijkstra algorithm implementation
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 20.03.2015 г. 18:37:54 ч.
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use open ':encoding(utf8)';
use List::Util qw/pairs reduce/;
use experimental qw/autoderef/;

use v5.012;

my %G;

while (<>) {
    if (index $_, '?') { 
        chomp;
        # ( $a, $b, $w ) = split ' ';
        my ( $a, $b, $w ) = /\w+/g;
        
        $G{$a} ||= [];          # init the $a elem of %G 
        push $G{$a}, ($b, $w);  # mind the autoderef !
    } else {
        my ( $s, $e ) = /\w/g;

        my (%out, %via);
        my %dist = ($s => 0);

        while ( keys %out != keys %G ) {

            # find the node with the minimum weight in the
            # accumulated distances, which has not yet been
            # visited => reduce phase
            #
            # all other (visited, or unreachable)
            # nodes should not be considered => grep phase
            #
            my $cnode = reduce {
                return $dist{$a} < $dist{$b} ? $a : $b
            } grep { 
                not exists $out{$_} and defined $dist{$_} 
            } keys %dist;

            ( defined($cnode) and $cnode ne $e ) or last;

            my $cdist = $dist{$cnode} || 0;

            $out{$cnode} = 1;

            foreach ( pairs @{$G{$cnode}} ) {
                my ($n, $w) = @$_;

                # if the current_distance + distance
                # of the node_inspected is less
                # than the distance so far calculated
                # for the node_inspected, then 
                # replace
                if ( not defined $dist{$n} 
                    or $cdist + $w < $dist{$n} ) {

                    $dist{$n} = $cdist + $w;
                    $via{$n} = $cnode;
                }
            }
        }

        say $s, " to ", $e, " is ", 
            defined $dist{$e} ? $dist{$e} : '∞';
    }
}

