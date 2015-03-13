#!/usr/bin/perl

use warnings;
use strict;
use v5.012;

# change the output record separator 
local $, = ", ";

my $a = "larodi";
my $s_ref = \$a;        # this is a reference to $a. it IS scalar

# same as $href = { 'a' => 10, 'b' => 20 } 
my %b = ( 'a' => 10, 'b' => 20);
my $href = \%b;         # this is a reference to %b. it IS scalar (!)

# same as $ary_ref = [qw/one two three.../]
my @ary = qw/one two three four/;
my $ary_ref = \@ary;    # this is a reference to @ary. it IS... you know what.


# simple sub to check the type of the reference 
sub check {
    my ($x, $y) = @_;
    
    # the ref operator returns 'SCALAR', or 'ARRAY', or... 
    # with respect to the type of the reference

    ref $x eq 'SCALAR'
        and say "GOT SCALAR REF";

    ref $x eq 'ARRAY'
        and say "GOT ARRAY REF";
}

say $s_ref, $href, $ary_ref;
say ref $s_ref; 

check $s_ref;
check $href;
check $ary_ref;

say @$ary_ref;      # deref the array ref
                    # will output one, two, three

say $$s_ref;        # deref the scalar

say $ary_ref->[0];  # deref and get the first elem
say $href->{'a'};               # deref and get the 'a' elem

say @{$ary_ref}[0,1];           # array slice over deref'd arrayref
say @{$href}{'a'..'b'};   # array slice over deref'd hashref

=cut

   Value slices of arrays and hashes may also be taken with postfix
   dereferencing notation, with the following equivalencies:

              $aref->@[ ... ];  # same as @$aref[ ... ]
              $href->@{ ... };  # same as @$href{ ... }

   Postfix key/value pair slicing, added in 5.20.0 and documented in the
   Key/Value Hash Slices section of perldata, also behaves as expected:

             $aref->%[ ... ];  # same as %$aref[ ... ]
             $href->%{ ... };  # same as %$href{ ... }

=cut

