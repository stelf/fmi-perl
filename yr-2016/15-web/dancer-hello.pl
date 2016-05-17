#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use Dancer;

get '/hello/:name' => sub {
  return "Hello there, " . param('name');
};

dance;
