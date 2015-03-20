#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: functest.pl
#
#        USAGE: ./functest.pl  
#
#  DESCRIPTION: function arguments chaining 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 12:11:29 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

# calling 'b' here is possible because of the '&' before it, 
# which will not only preserve the @_ array, but also force code
# reference context, that suggest to the compiler, that there 
# would be a 'b' function somewhere in time, even though it
# is not yet present at compile time

sub a { say @_ and &b }
sub c { say @_ }
sub b { say @_ and &c }

my $coderef = sub { &a } ;

$coderef->(qw/some params/);

