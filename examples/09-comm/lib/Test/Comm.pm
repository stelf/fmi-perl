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
	return "foo";
}

func comm_decode_line(HashRef $comm, Str $line, Maybe[Str] $eol?)
{
	...;
}

1;
