#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use URI;

my $uri = URI->new("http://www.metacpan.org/pod/URI");

say "scheme: " . $uri->scheme;
say "path: " . $uri->path;
say "fragment: " . $uri->fragment;
