#!/usr/bin/env perl

use strict;
use warnings;
use v5.012;

use App::Daemon qw( daemonize );
daemonize();

my @text = ("i'm a daaamon", "yeah im a daaemon", "daeeemon eye aaaam", "yeayeayeayeayh yeaaah");

while (1) {
    sleep rand 3;
    say $text[rand $#text];
}

