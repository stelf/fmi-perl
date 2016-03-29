#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use utf8;

sub return_where_some_conditions {
  my ($cond1, $cond2, %humans) = @_;

  grep $cond1->(%humans), grep $cond2->(%humans), keys %humans;
}

my %h = (
  John => [ 1, 21 ],
  Hodor => [ 1, 18 ],
  Khaleesi => [ 1, 34 ],
  Shawn => [ 0, 24 ],
  'decata na shawn' => [ 0, 8 ],
);

$, = ' ';
say return_where_some_conditions(
  sub { 
    my %humans = @_;

    $humans{$_}->[0] == 1 
  },
  sub { 
    my %humans = @_;

    $humans{$_}->[1] > 18 
  },
  %h);


###

sub alias_me {
  $_[0] = 10;
  $_[1] = 11;
}

sub non_alias {
  my @ls = @_;

  $ls[0] = 10;
  $ls[1] = 11;
}

my @nums = (1, 2, 3);
say @nums;
non_alias(@nums);
say @nums;

###

sub make_iterator {
  my @iterable = @_;
  my $idx = 0;

  return {
    'бъди_лощ' => sub {
      $idx = $#iterable + 1;
    },
    next => sub {
      return '' if $idx == @iterable;

      return $iterable[$idx++];
    }, 
    has_next => sub {
      return $idx != @iterable;
    }
  }
}

my $iter = make_iterator('alice', 'bob', 'clara', 'many');

# $iter->{'бъди_лощ'}->();

while ($iter->{has_next}->()) {
  say $iter->{next}->();
}

sub make_infinity {
  my $idx = 0;

  return sub {
    return $idx++;
  };
}

my $inf = make_infinity();

sub take {
  my ($k, $stream) = @_;

  my @res;
 
  for my $i (0..$k) {
    push @res, $stream->();
  }

  return @res;
}

say take(10, $inf);
say take(10, $inf);

###

sub fib {
  my @fibs = (0, 1);

  return sub {
    my $nth = shift;

    say "fibs: $#fibs";

    return $fibs[$nth] if $nth <= $#fibs;

    for my $i (@fibs .. $nth) {
      $fibs[$i] = $fibs[$i-1] + $fibs[$i-2];
    }

    return $fibs[$#fibs];
  }
}

my $fib_gen = fib();

say $fib_gen->(2);
say $fib_gen->(3);
say $fib_gen->(8);
say $fib_gen->(6);
say $fib_gen->(42);

###

sub make_computation {
  my ($sub, @cache) = @_;

  return sub {
    my $nth = shift;

    $sub->($nth, \@cache);

    return $cache[$#cache];
  }
}

my $fib_gen_gen = make_computation(
  sub {
    my ($nth, $fibs) = @_;

    return $$fibs[$nth] if $nth <= $#@fibs;

    for my $i ($#@fibs .. $nth) {
      $$fibs[$i] = $$fibs[$i-1] + $$fibs[$i-2];
    }
  }, (0, 1));

say $fib_gen_gen->(2);
say $fib_gen_gen->(3);
say $fib_gen_gen->(8);
say $fib_gen_gen->(6);
say $fib_gen_gen->(42);

my $gen_numbers = make_computation(
  sub {
    my ($nth, $nums) = @_;

    for my $i ($#@nums .. $nth) {
      $$nums[$i] = $$nums[$i-1] + 1;
    }
  }, (0));

say $gen_numbers->(3);
