#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use Data::Dumper;


# Hello.psgi
my $app = sub {
    my $env = shift;

    return [
      200, 
      [ 'Content-Type' => 'text/plain' ], 
      [ "Hello World\n",
        Dumper($env)
      ]
    ];
};

return $app;
