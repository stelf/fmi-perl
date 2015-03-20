#!/usr/bin/perl

use v5.012;
use strict;

say "command line arguments : @ARGV  ";

# int uses $_ by default
# grep filters array elements testing each against a expression/block
say "numeric arguments are ",
    join ' ', grep int, @ARGV;

say "numeric arguments greater than 10 : ",
    join ' ', grep { int($_) > 10 } @ARGV;

say "arguments that when incremented by 1 give odd number : ",
    join ' ', 
        grep {
            int and $_++ and $_ & 1; 
        } @ARGV ;

say "arguments sorted alpabetically : ", join ', ' , sort(@ARGV);

# <=> compares numbers
# sort takes first argument - evaluation function
# (note:  sort may not take first argument code, but directly list)
say "numeric arguments sorted numerically : ".
join ', ', sort { $a <=> $b } grep(int, @ARGV);

