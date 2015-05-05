#
#===============================================================================
#
#         FILE: Polygon.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 04/21/2015 01:12:45 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
 
use v5.012;

package Polygon;

# has to be the first thing to import
use Moose;

use Point;

use List::Util qw/sum/;
use MooseX::Method::Signatures;

has 'points' => ( isa => 'ArrayRef[Point]', is => 'rw', coerce => 1 );

method perim { 
    my @pnts = (@{$self->points}, $self->points->[0]);

    my $len = sum map {
        $pnts[$_]->dist($pnts[$_ - 1])
    } 1..$#pnts;

    return $len;
};

my $cnt = 0;

after 'perim' => sub {
    ++$cnt % 100 or say '!!! BAW !!!';
};

# __PACKAGE__->meta->make_immutable;

0x804;

