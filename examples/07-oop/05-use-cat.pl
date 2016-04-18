#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use FindBin;
use lib "$FindBin::Bin/lib";

use PPP::Cat;
use PPP::Plankton;
use PPP::LightSource;
use PPP::LightSourceCranky;
use PPP::SuperCandle;
use PPP::Glowstick;


my $kitty = PPP::Cat->new(
  name => 'Kat', 
  diet => 'Packs of Whiskas',
  birth_year => 2007
);

my $now = (localtime)[5] + 1900;

say $kitty->name . " eats " . $kitty->diet . 
  " and is " . $kitty->age() . " years old";

$kitty->play_with_ppl();
$kitty->play_with_mice("Jerry");

$kitty->diet('Vegan mice');
say $kitty->diet;

my $planky = PPP::Plankton->new(
  name => 'Plankton',
  birth_year => 1000,
  interval => 5,
);

say $planky->strobe();

###

my $ls = PPP::LightSource->new();

$ls->light();
say $ls->enabled;
$ls->extinguish();
say $ls->enabled;

my $lsc = PPP::LightSourceCranky->new();
$lsc->extinguish();

my $sc = PPP::SuperCandle->new();
say $sc->candle_power;

my $gs = PPP::Glowstick->new();
$gs->light();
say $gs->enabled;
$gs->extinguish();
say $gs->enabled;
