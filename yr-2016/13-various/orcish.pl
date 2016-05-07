#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


my $var = 0;

$var ||= 1;
say '$var ||= 1: ', $var;

$var ||= "sad";
say '$var ||= "sad": ', $var;

$var = '';

$var ||= "sad";
say '$var ||= "sad": ', $var;

$var = undef;

$var ||= 0xDEADBEEF;
say '$var ||= 0xDEADBEEF: ', $var;

$var = 0;

$var //= 123;
say '$var //= 123: ', $var;

$var = undef;

$var //= "homemoaning";
say '$var //= "homemoaning": ', $var;

# Orcish operator
my @cache;

sub busy_func {
  sleep 2;
  return shift() - 1;
}

sub dec {
  my $arg = shift;

  $cache[$arg] //= busy_func $arg;

  return $cache[$arg];
}

my $two = dec(1);
say $two;

my $three = dec 3;
say $three;

my $two_2 = dec(1);
say $two_2;
