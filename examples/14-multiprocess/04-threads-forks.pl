#!/usr/bin/env perl

use forks;
use forks::shared;
use warnings;
use strict;
use v5.012;

my $notshared = 10;
my $shared : shared;

$shared = 'baba';

sub short_runner {
    my @args = @_;
    say 'started long job : ', join ',', @args;
    $notshared = 1000;
    say $notshared;
    sleep 4;
    $shared = 'not baba';
    return $notshared;
}

sub long_runner {
    my @args = @_;
    say 'started short job : ', join ',', @args;
    say 'lets sleep 2 seconds to see if the notshared var changed its value';
    sleep 10;
    say 'notshared var: ', $notshared;
    say 'shared var: ', $shared;
    $notshared = -100;
}

my $thr = threads->create(\&long_runner, 10, 20, 30);
my $thr2 = threads->create(\&short_runner, 10, 20, 30);

say 'thread long_runner returned: ', $thr->join;
say 'thread short_runner returned: ', $thr2->join;


