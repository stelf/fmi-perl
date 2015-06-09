#!/usr/bin/perl

use v5.012;

use strict;
use warnings;
use bignum;

use Math::ContinuedFraction;
use Text::ASCIIMathML;
use Dancer;
use Data::Dumper;

sub cnoml { 
	my ($num, $denom) = @_;
	my $parser = new Text::ASCIIMathML();
    	my $cf = Math::ContinuedFraction->from_ratio($num, $denom);
	my @fracs = @{$cf->to_array}; 
	my $str = join('', map { "$_+1/("  } @fracs).(')' x scalar($#fracs));
	$str =~ s/(\d+) \+ 1 \/ \( \)/$1/ex;
	debug $str;
	$parser->TextToMathML($str);
}

get '/fraction/:num/:denom' => sub {
	my $num = param('num');
	my $denom = param('denom');
	$num = abs int $num;
	$denom = abs int $denom;
	$num ||= 1;
	$denom ||= 1;
#	template 'mathml',
#		{ content => cnoml($num, $denom) };
	return cnoml $num, $denom;
};

get '/' => sub { 
	template 'main.tt';
};

dance;
