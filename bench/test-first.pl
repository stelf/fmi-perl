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

# get some random numbers
my @nums = map { int rand 950 } 1..1000;


# prepare test appraoches 
my $app = {
    'for(index)' => sub { 
        for (my $i =0; $i<$#nums; $i++)  {
           return $nums[$i] if $nums[$i] > 900;
        }
    },
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

use Test::More tests => 4;
# make sure we actually get the needed result
ok($app->{$_}->() > 900, "$_ is good") for keys %{$app};

# time these...
timethese 200000, $app;
