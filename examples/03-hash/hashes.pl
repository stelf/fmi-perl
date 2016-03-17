#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

# Adding items/declaration
my %fav_scenes;
$fav_scenes{'first'} = 'Hunking in the thunk';
$fav_scenes{'second'} = 'Thunking in the hunk';
$fav_scenes{'third'} = 'Marry sound united';

while (my ($pos, $name) = each %fav_scenes) {
  say "$pos => $name";
}

say '';

my %other_scenes = (
  eden => 'Was here',
  small => 'Crux and some lobotomy',
  long => 'Crying in the rain',
);

for my $key (keys %other_scenes) {
  say "$key $other_scenes{$key}";
}

for my $val (values %fav_scenes) {
  say "No ranking!!! $val";
}

say '';

# Indexing
sub get_by_key {
  return $other_scenes{+shift};
}

say get_by_key('small');

say '';

# exists/defined
say "Undefined betty" if !defined $other_scenes{'betty'};

$other_scenes{'betty'} = '';

say "Giving you some betty" if exists $other_scenes{'betty'};
say "Giving you another betty" if $other_scenes{'betty'};

say '';

# Slices
my %cats;
@cats{qw(Jack Brad Mars Grumpy)} = (12, 15, 9, 3);

for my $key (keys %cats) {
  say "$key is $cats{$key} years old.";
}

my %pseudo_cats = (
  John => 30,
  Price => 21,
  Limbo => 66,
);

@cats{keys %pseudo_cats} = values %pseudo_cats;
say "\nMerged cats:";

for my $key (keys %cats) {
  say "$key is $cats{$key} years old.";
}

say '';

# Idioms
my @items = (1, 1, 3, 4, 5, 6, 6, 6, 7, 8);
my %uniq;
undef @uniq{@items};

say "before: @items";

my @uniqArr = sort(keys %uniq);
say "after: @uniqArr";

# Caching stuff
{
  my %cache;

  sub create {
    sleep(2);
  }

  sub fetch {
    my $id = shift;
    $cache{$id} //= create($id);
    return $cache{$id};
  }

  for my $val (1, 1, 1, 2, 3, 4, 4, 4, 4, 4, 5) {
    say "trying to fetch...";
    fetch($val);
    say "fetched...";
  }
}

# Slurpy hashes
sub many_args {
  my %args = @_;

  my $arg1 = $args{arg1};
  my $arg2 = $args{arg2};

  say $arg1 if defined $arg1;
  say $arg2 if defined $arg2;
}

say 'first';
many_args(arg1 => 1);
say 'second';
many_args(arg2 => 2);
say 'both';
many_args(arg1 => 1, arg2 => 2);
say 'none';
many_args();

# Empty hashes
my %empty_inside;
say "Gonna loop you...";
while (my ($key, $value) = %empty_inside) {
  say "nay..";
}

$empty_inside{betty} = 'ronnie';
# while (my ($key, $value) = %empty_inside) {
#   say "some more and...";
# }
