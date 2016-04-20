#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use Set::Functional qw/:all/;


$, = ' ';
my @uniq = setify 1..10, 5..10, 1..15;
say sort { $a <=> $b } @uniq;

my @cartesian = cartesian [setify 1..3], [setify 1..2];
map { print @$_, ' ' } @cartesian;
say '';

my @diff = difference [1..10], [6..15];
say @diff;

my @diff_mult = difference [1..10], [6..15], [2..4];
say @diff_mult;

my @disjoint = disjoint [1..10], [6..15];
map { print @$_, ' ' } @disjoint; 
say '';

my @disjoint_mult = disjoint [1..10], [6..15], [2..4];
map { print @$_, ' ' } @disjoint_mult; 
say '';

my @distinct = distinct [1..10], [6..15];
say @distinct;

my @intersect = intersection [1..10], [6..15];
say @intersect;

my @symm_diff = symmetric_difference [1..10], [6..15];
say @symm_diff;
