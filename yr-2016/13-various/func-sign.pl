#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use Method::Signatures;


func combine(Str $pesho, Int $gosho) {
  return $pesho . ' + ' . $gosho;
}

say combine("pesho", 23);

sub combine {
}
