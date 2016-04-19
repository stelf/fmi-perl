#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use List::Util qw/
  reduce any all none notall first max maxstr min minstr product sum sum0
  pairs unpairs pairkeys pairvalues pairfirst pairgrep pairmap shuffle uniqnum
  uniqstr
/;
use Data::Dumper;

$, = ' ';

# reduce
my @nums = (1, 2, 3, 4, 5);
my $sum = reduce { $a + $b } @nums;
say $sum;

my @words = qw/The quick brown fox jumped over the lazy dog/;
my $sentence = reduce { $a . ' ' . $b } @words;
say $sentence;

sub arr_len {
  reduce { $a + 1 } 0, @_;
}
say arr_len(@words);
say arr_len(@nums);

my @lsls = ([4, 2, 2], [2, 2], [0, 4]);
my $flatten = reduce { [@$a, @$b] } @lsls;

say @$flatten;

# any/all notall/none
say "Has long words: " . any { length > 5 } @words;

=pod
my $even = all { $_ % 2 }, (0, 2, 4);
say "All even? $even";
=cut

# max/min maxstr/minstr
say max @nums;
say minstr @words;

# pairs/unpairs
my %ocelots = (
  Babou => 'Salvador Dali',
  Grino => 'Salvador Dali',
  unnamed => 'Salvador Dali',
  Ita => 'Lily Pons', 
  unnamed => 'Gram Parsons'
);

for my $pair (pairs %ocelots) {
  say $pair->key . " was owned by " . $pair->value;
}

# sorted by owner names
my @sorted_ocelots = unpairs sort { $a->value cmp $b->value } pairs %ocelots;
say Dumper(@sorted_ocelots);

# pairgrep
my $cnt_dalis_named_ocelots =
  pairgrep { $a ne 'unnamed' && $b =~ /Dali$/ } %ocelots;
say "Dali had $cnt_dalis_named_ocelots famous ocelots";

# pairmap
my %ocelots_owner_suffix =
  pairmap { $a .= " $b", $b } %ocelots;
say Dumper(%ocelots_owner_suffix);
