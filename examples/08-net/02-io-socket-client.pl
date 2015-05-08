#!/usr/bin/perl

use v5.12;
use strict;
use warnings;

use IO::Socket::INET;

MAIN:
{
	my $s = IO::Socket::INET->new(PeerAddr => 'localhost:daytime',
	    Proto => 'tcp') or
	    die("Could not create the client socket: $!\n");

	my $line = <$s>;
	say "The remote host said: $line";
	close($s);
}
