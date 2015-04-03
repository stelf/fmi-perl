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
	connect($s, pack_sockaddr_in($port, $addr)) or
	    die("connect(): $!\n");

	say $s "hello";
	my $line = <$s>;
	say "And the daytime service replied: $line";
	close($s);
}
