#!/usr/bin/perl
#
use strict;
use warnings;
use v5.012;

my $string = 'incoming call from 0887466321 at 19:30';
my %digs = qw {1 one 2 two 3 three 4 four 5 five 6 six 7 seven 8 eight 9 nine };

$string =~ s/^.*?(\d+).*$/$1 placed a call/; 
say $string;

$string =~ s/\d+/{$&}/;           # ограждаме цифрите с {}
$string =~ s/\d/ $digs{$&}/g; # заменяме намерените цифри с елемент от $digs
say $string; 

$string =~ tr/a-z/B-Z_/;
say $string; 

$string =~ tr/B-Z_/a-z/;
say $string; 

$string =~ s/\b (\w+?) \b/[$1]/gx;
say $string; 


