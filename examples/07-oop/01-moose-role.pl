#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;


package LivingBeing {
  use Moose::Role;

  requires qw/name age diet/;
}

package CalculateAgeFrom::BirthYear {
  use Moose::Role;

  has 'birth_year', 
    is => 'ro',
    isa => 'Int',
    default => sub { (localtime)[5] + 1900 };
    
  sub age {
    my $self = shift;
    my $year = (localtime)[5] + 1900;

    return $year - $self->birth_year;
  }
}

package Cat {
  use Moose;

  has 'name', is => 'ro', isa => 'Str';
  has 'diet', is => 'rw', isa => 'Str';

  has 'birth_year', 
    is => 'ro',
    isa => 'Int',
    default => sub { (localtime)[5] + 1900 };

  with 'LivingBeing', 'CalculateAgeFrom::BirthYear';
}
