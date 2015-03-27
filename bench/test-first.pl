#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: test-first.pl
#
#        USAGE: ./test-first.pl  
#
#  DESCRIPTION: test different approaches to first 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 27.03.2015 г. 18:52:36 ч.
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

use Benchmark;
use List::Util qw/first reduce/;
use Test::More tests => 3;

my @nums = map { int rand 950 } 1..1000;

my $app = {
    'foreach' => sub { 
        for (@nums) { 
           return $_ if $_ > 900;
        }
    },
    'first' => sub {
        return first { $_ > 900 } @nums;
    }, 
    'grep' => sub {
        return (grep { $_ > 900 } @nums) [0]
    },
};

ok($app->{$_}->() > 900, "$_ is good") for keys %{$app};
timethese 100000, $app;
