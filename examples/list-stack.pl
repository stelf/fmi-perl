#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: stack.braces.pl
#
#        USAGE: ./stack.braces.pl  
#
#  DESCRIPTION: example matching stack braces
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 10:24:56 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

my $bstr = $ARGV[0] || "ds[dsds[(asd)]]";

# each opening brace has a matching closing brace
my %bmatch = qw/( ) [ ] { }/;
my %rmatch = qw/) ( ] [ } {/;

# stack var
my @s;

for my $pos (1..length($bstr)) { 
    my $c = substr $bstr, $pos - 1, 1;
    
    # push in stack if exists such characater
    # that is assumed to be an opening brace 
    
    exists $bmatch{$c} 
        and push @s, $c;
    
    # if exists a closing brace that is matched 
    # against opening 
    if ( grep { $_ eq $c } values %bmatch ) {
        scalar @s or die "too many closing";
        $bmatch{pop @s} eq $c or die "mismatch at [$pos]";
    }
}

#if something is left in the stack -> there's a mismatch
scalar @s and die "mismatch";

say "OK"


