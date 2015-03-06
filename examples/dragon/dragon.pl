#!/usr/bin/perl

use 5.012;
use strict;
use warnings;

use Getopt::Std;

sub usage($) {
	my ($err) = @_;
	my $s = <<USAGE
Usage: dragon [-m mode] generation

Available options:
	-m	the output mode; use '-m list' for a list

The generation must be a positive integer.
USAGE
	;

	if ($err) {
		die($s);
	} else {
		print $s;
	}
}

sub version()
{
	say 'dragon 0.01';
}

MAIN:
{
	my %opts;
	getopts('hm:V', \%opts) or usage(1);
	version() if $opts{V};
	usage(0) if $opts{h};
	exit(0) if $opts{h} || $opts{V};

	my $mode = 'turns';
	if (exists($opts{m})) {
		my %modes = (
			turns	=> 'the sequence of turns',
			turtle	=> 'turtle graphics commands',
		);

		if ($opts{m} eq 'list') {
			say 'Available output modes:';
			say "$_\t$modes{$_}" for sort keys %modes;
			exit(0);
		}
		usage(1) unless exists $modes{$opts{m}};
		$mode = $opts{m};
	}

	usage(1) unless @ARGV == 1 && $ARGV[0] =~ /^[1-9][0-9]*$/;
	my $generation = $ARGV[0];

	my @turns = (1);
	for my $gen (2..$generation) {
		@turns = (@turns, 1, map { 1 - $_ } reverse @turns);
	}

	if ($mode eq 'turns') {
		say @turns;
	} elsif ($mode eq 'turtle') {
		say 'forward 10';
		for my $turn (@turns) {
			say $turn? 'right': 'left', ' 90';
			say 'forward 10';
		}
	}
}
