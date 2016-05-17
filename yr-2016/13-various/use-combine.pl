#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use v5.014;


use Encode qw/encode/;

use Harvester;

say encode('UTF-8', Harvester::combine('бяла роза', 'Пешо'));
