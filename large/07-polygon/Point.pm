#
#===============================================================================
#
#         FILE: Point.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 04/21/2015 01:12:10 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
 
package Point;

use Moose;
use Method::Signatures;

has 'x' => ( isa => 'Num', is => 'rw' );
has 'y' => ( isa => 'Num', is => 'rw' );

method dist(Point $p) {
   sqrt(
       ( $self->x - $p->x ) ** 2 +
       ( $self->y - $p->y ) ** 2 
   );
} 


use Moose::Util::TypeConstraints;

coerce 'Point' =>
   from 'HashRef[Num]' =>
    via { 
       Point->new( %{$_} ) 
   };

subtype 'Points' 
    => as 'ArrayRef[Point]';

coerce 'ArrayRef[Point]' => 
    from 'ArrayRef[HashRef[Num]]' =>
        via sub { 
            [ map { Point->new( %$_ ) } @{$_[0]} ]
        };

# __PACKAGE__->meta->make_immutable;

0x805;

