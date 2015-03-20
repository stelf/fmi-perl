#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: bfs-walk.pl
#
#        USAGE: ./bfs-walk.pl  
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
#      CREATED: 20.03.2015 г. 16:31:31 ч.
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use Method::Signatures;
use v5.012;

my %G;

func bfs(Str $s is ro, Str $e is ro) {
#sub bfs {
#    my ($s, $e) = @_;
    my @queue = ($s);
    my %visited;

    while (@queue) {
        my $node = shift @queue;

        return 1 if $node eq $e; 

        $visited{$node} = 1;
        
        push @queue, 
            grep { not exists $visited{$_} } 
                @{$G{$node}}; 
    }
    
    return undef;
}

while (<>) {
    # this reads the configuration of the graph in %G
#    if (index($_, ':') > 0) {
    if (/[:]/) {
        my ($v, $incident) = split ':';
        $G{$v} = [ grep length, split ' ', $incident ];
    }

#    if (index($_, '?') > 0) {
    if (/[?]/) {
        my ($s, $e) = split ' ', substr $_, 1;
        exists $G{$s} or say 'NO' and next;
        exists $G{$e} or say 'NO' and next;
        say bfs($s, $e) ? 'YES' : 'NO';
    }
}


