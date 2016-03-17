#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

# Indexing
my @arr = ('pesho', 'misho', 'gosho');
say "Last (-1): $arr[-1]";
say "Last (\$#): $arr[$#arr]";
say "Last (scalar - 1): $arr[scalar @arr - 1]";

my $last = @arr - 1;
say "Last (in scalar ctx): $arr[$last]";

say '';

# Assignment
my @cats = ('murr', 'purr', 'hurr');
$, = ' ';
say @cats;

my @dogs;
$dogs[2] = 'bau';
$dogs[1] = 'meow';
$dogs[0] = 'grrr';

say @dogs;

say '';

# Opearations
my $dog = shift(@dogs);
say "A doggy says: '$dog'";

my $poppedDog = pop(@dogs);
say "A popped doggy says: '$poppedDog'";

my ($lastDog) = @dogs;
say "I'm not a very doggy dog: '$lastDog'";

push @dogs, 'grr';
say "'grr' is back in town: @dogs";

unshift @dogs, 'bau';
say "'bau' has the crown: @dogs";

say '';

# Slices
say "Last cats: @cats[-1, -2]"; # Try "Last cats: " . @cats[-1, -2];

my @mixed = (@cats, @dogs)[1..3];
say "Some cats and a dog: @mixed";

say '';

# Flattening
sub take_pets_to_vet {
  my (@cats, @dogs) = @_;

  say "I'm a bug!";
}

take_pets_to_vet(@cats, @dogs);

my @fakers = (1..10, (11..20, (21..30)));
say "Flat: @fakers";

my @fakersTwo = (1..10, 11..20, 21..30);
say "Flat: @fakersTwo";

my @fakersThree = (1..30);
say "Flat: @fakersThree";
