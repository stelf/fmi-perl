#!/usr/bin/perl

use strict;
use warnings;
use v5.012;


my @funs;

{
    my $i = 0;

    do { 
        push @funs, 
        sub {
            my $c = shift;
            say "create func with", $c; 
            return sub { 
                say ref $c;
                say "-->", $c;
            }
        }->(+$i);
    } while ($i++ < 5);
}

$_->() foreach @funs;
