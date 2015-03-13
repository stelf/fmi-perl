#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;

use GD::SVG;
use GD::Simple;
use experimental qw/say switch/;

# my $r = 90;
# my $lres = 'FX';
# my %rules = (
#    'X' => 'X+YF+',
#    'Y' => 'FX-Y',
# );
# my $draw = qr/F/;

# my $r = 90;
# my $lres = 'FX+FX+';
# my %rules = (
#     'X' => 'X+YF',
#     'Y' => 'FX-Y',
# );

# my $r = 90;
# my $lres = 'L';
# my %rules = (
#   'L' => '+RF-LFL-FR+',
#   'R' => '-LF+RFR+FL-',
# );
#
#
# my $draw = qr/F/;
# my $r = 90;
# my $lres = 'F+F+F+F';
# my %rules = (
#    'F' => 'F+F-F-F+F'
# );

my $r = 60;
my $draw = qr/[AB]/;
my %rules = ( 
    'A' => 'B-A-B',
    'B' => 'A+B+A'
 );
my $lres = 'A';

my $gen = $ARGV[0] || 1;

while ($gen--) { 
    $lres = join '',
        map { 
            exists ($rules{$_}) 
                ? $rules{$_}
                : $_;
        } split '', $lres;
            
    defined $ARGV[1] and say $lres;
}

# Print IMAGE
# GD::Simple->class('GD::SVG');
my $img = GD::Simple->new(800, 800);

$img->angle(0); $img->moveTo(200, 600);
$img->fgcolor('black'); $img->penSize(2, 2);

foreach my $c (split '', $lres) {
    given ($c) { 
        $img->line(80.0/$ARGV[0]) when /$draw/;
        $img->turn(-$r) when '+';
        $img->turn(+$r) when '-';
    }
}

unless (defined $ARGV[1]) {
    binmode STDOUT;
    print $img->png;
}

