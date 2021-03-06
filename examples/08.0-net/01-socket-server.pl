#!/usr/bin/perl

use v5.12;
use strict;
use warnings;

use Socket;

MAIN:
{
	my (undef, undef, $port, $protoname) = getservbyname('daytime', 'tcp') or
	    die("getservbyname(): $!\n");
	my (undef, undef, $proto) = getprotobyname($protoname) or
	    die("getprotobyname($protoname): $!\n");
	say "get*byname() returned proto name '$protoname' proto '$proto' port '$port'";
	socket(my $s, PF_INET, SOCK_STREAM, $proto) or
	    die("socket(): $!\n");
	say "socket: $s";

	my $addr = inet_aton('localhost');
	say "addr: $addr";
	bind($s, pack_sockaddr_in($port, $addr)) or
	    die("bind(): $!\n");
	setsockopt($s, SOL_SOCKET, SO_REUSEADDR, 1) or
	    die("setsockopt(): $!\n");
	listen($s, 2);

	while (accept(my $cli, $s)) {
		my $peer = getpeername($cli);
		my ($port, $addr) = sockaddr_in($peer);
		my $host = inet_ntoa($addr);
		say "Got a connection from $host:$port";

		my $line = <$cli>;
		print $cli $line;
		close($cli);
	}
}
