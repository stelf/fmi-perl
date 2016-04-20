#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use List::MoreUtils qw/:all/;
use List::Util qw/pairmap/;


$, = ' ';

# all/any one
my @nums = (1, 2, 3, 4, 5, 6);
my @undef;
say "all positive"
  if all { $_ >= 0 } @nums;

say "all positive_undef"
  if all { $_ >= 0 } @undef;

say "not all positive undef three-value"
  unless all_u { $_ >= 0 } @undef;

my @nums_two = (1, -2, -3, -5);
say "atleast one positive"
  if any { $_ >= 0 } @nums_two;

say "not atleast one positive undef"
  unless any { $_ >= 0 } @undef;

say "not atleast one positive undef three-value"
  unless any { $_ >= 0 } @undef;

say "exactly one positive"
  if one { $_ >= 0 } @nums_two;

# transformations
say '';
my @pets = ('cat', 'dog', 'mamut');
say "Pets: @pets";
insert_after_string "dog", "mouse" => @pets;
say "Pets with a mouse: @pets";

my @idxes = (0..$#pets);
my %idxed_pets = zip @idxes, @pets;
pairmap { say "$b is at $a" } %idxed_pets;

my @x = (1, 1, 1, 2, 2, 3, 4, 5, 5);
my @uniques = uniq @x;
say "Uniques: @uniques";

my @singletons = singleton @x;
say "Singletons: @singletons";

# partitions
say '';
my @nums_three = (1, 2, -3, -5, 1, 2, -4, -5);

my @after_neg_five = after { $_ == -5 } @nums_three;
say "Nums after neg five: @after_neg_five";

my @after_positive = after_incl { $_ < 0 } @nums_three;
say "Nums after positive: @after_positive";

my @positive_negative = part { $_ < 0 } @nums_three;
say "Positive: @{$positive_negative[0]}";
say "Negative: @{$positive_negative[1]}";

# iteration
my @letters = 'a'..'z';
say "Letters in columns of 4:";
my $it = natatime 4, @letters;
my @letters_rows;
while (my @four = $it->()) {
  say @four;
  push @letters_rows, \@four;
}

my $flipped = each_arrayref @letters_rows;
while (my @cols = $flipped->()) {
  say grep { defined } @cols;
}

# searching
say '';
my @negative_idxes = indexes { $_ < 0 } @nums_three;
say "Neg nums at: @negative_idxes";

say "First neg at: ", firstidx { $_ < 0 } @nums_three;
say "Last neg at: ", lastidx { $_ < 0 } @nums_three;
say "Only neg four at: ", onlyidx { $_ == -4 } @nums_three;

# Search people who have grades less than 4
say '';
my @people = (
  { name => 'Pesho', grade => 3 },
  { name => 'Miro', grade => 4 },
  { name => 'Ivan', grade => 4 },
  { name => 'Dragan', grade => 2 },
  { name => 'Monika', grade => 5 },
  { name => 'Maria', grade => 3 },
);

my @first_good =
  bsearch { $_->{grade} - 4 } 
    sort_by { $_->{grade} } @people;

for my $st (@first_good) {
  say "$st->{name} ain't so good";
}

say "First neg val: ", firstval { $_ < 0 } @nums_three;
say "First neg res: ", firstres { $_ < 0 } @nums_three;
