#!/usr/bin/perl

use v5.12;
use strict;
use warnings;

use IO::Socket::INET;

MAIN:
{
	my $s = IO::Socket::INET->new(LocalAddr => 'localhost:echo',
	    Proto => 'tcp', Listen => 2, ReuseAddr => 1) or
	    die("Could not create the client socket: $!\n");

	while (my $cli = $s->accept()) {
		say "A connection from ".$cli->peeraddr().":".$cli->peerport();

		my $line = <$cli>;
		print $cli $line;
		close($cli);
	}
}
