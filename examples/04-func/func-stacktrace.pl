#!/usr/bin/perl

use v5.012;
use warnings;
use strict;

sub d {
    my $b = shift; 

    if ($b) {
        print "in function, now call... ";
        $b->();		
    }

    wantarray 
        ? ( 10, 20, 30 )
        : "scalar single"
}

d( 
    sub { 
        use Devel::StackTrace;
        my $trace = Devel::StackTrace->new;
        print $trace->as_string; # like carp
        print "baba \n" 
    } 
);

my @x = d;
my $y = d;

print "[@x] [$y]";

