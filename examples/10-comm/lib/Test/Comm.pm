#!/usr/bin/perl

use v5.12;

package Test::Comm;

use v5.12;
use strict;
use warnings;

use Exporter;
use Method::Signatures;

our @ISA = qw/Exporter/;

our %EXPORT_TAGS = (
	comm	=> [ qw/comm_init comm_encode_text comm_decode_line/ ],
);

our @EXPORT_OK = (
	':comm', @{$EXPORT_TAGS{comm}},
);

func comm_init()
{
	return {
		lines => { },
	};
}

func comm_encode_text(HashRef $comm, Str $text, Str $tag)
{
	$text =~ s/[\r\n]*$//;

	my @lines = split /\n/, $text;
	push @lines, '' unless @lines;

	my $last = pop @lines;
	my @res = map { "$tag-$_" } @lines;
	return (@res, "$tag $last");
}

func comm_decode_line(HashRef $comm, Str $line, Maybe[Str] $eol? = "\n")
{
	if ($line !~ /^([A-Za-z0-9_.]+)([ -])(.*)/) {
		die("Invalid protocol line: $line\n");
	}
	my ($tag, $sep, $text) = ($1, $2, $3);


	if ($sep eq ' ') {
		my $lines = $comm->{lines}{$tag} // [];

		delete $comm->{lines}{$tag};
		return ($tag, join $eol, @{$lines}, $text);
	} else {
		push @{$comm->{lines}{$tag}}, $text;
		return ();
	}
}

1;
