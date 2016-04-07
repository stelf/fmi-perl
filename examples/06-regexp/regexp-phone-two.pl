#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;


my $area_code = qr/\+\d{3}\s|0/;
my $sep = qr/\s|-/;
my $op_code = qr/\d{3}/;

my $dashes = qr/(?<=$op_code\s)\d{2}-\d{2}-\d{2}/;
my $spaces = qr/(?<=$op_code-)\d{2} \d{2} \d{2}/;
my $phone = qr/\d{3} \d{3}|\d{6}|$dashes|$spaces/;

my $phone_reg_in = qr/(?<all>
    (?<acode>$area_code) # This matches area code of the form (+359 or 0)
    (?<opcode>$op_code)$sep?
    (?<phnum>$phone)
  )
  /x;

my $phone_reg = qr/\A$phone_reg_in\z/;

my %tests = (
  '+359 878 888 999' => 1,
  '+359 878888999' => 1,
  '+359 878-88 89 99' => 1,
  '+359 878 88-89-99' => 1,
  '0878 888 999' => 1,
  '0878888999' => 1,
  '0878-88 89 99' => 1,
  '0878 88-89-99' => 1,
  'abc0988 999 999accc  ' => 0,
  '0988-88-88-88' => 0,
);

for my $ph (keys %tests) {
  say "[$ph] successful" and next
    if ($tests{$ph} && $ph =~ $phone_reg) ||
       (!$tests{$ph} && $ph !~ $phone_reg);

  say "[$ph] not successful";
}

for my $ph (grep { $tests{$_} } keys %tests) {
  $ph =~ $phone_reg;

  say "telephone $+{all}";
  say "  $+{acode}/$+{opcode}/$+{phnum}";
}

my $ll = "+359 878 888 999,+359 878888999,+359 878-88 89 99,+359 878 88-89-99,0878 888 999,0878888999,0878-88 89 99,0878 88-89-99,abc0988 999 999accc  ,0988-88-88-88";

while ($ll =~ /$phone_reg_in/g) {
  say $&;
}
