#!/usr/bin/perl

use v5.12;
use strict;
use warnings;

use AnyEvent;
use AnyEvent::Handle;
use AnyEvent::Socket;

sub client_read($ $ $);

my %clients;

sub client_read($ $ $) {
	my ($handle, $line, $eol) = @_;

	my $count = 0;
	for my $h (values %clients) {
		next if $h eq $handle;
		$h->push_write("$line$eol");
		$count++;
	}
	$handle->push_write("Sent to $count others$eol");

	$handle->push_read(line => sub { client_read($_[0], $_[1], $_[2]); });
}

MAIN:
{
	my $cv = AnyEvent->condvar();

	my $clientId = 0;

	my $w = tcp_server undef, 8086, sub {
		my ($fh, $host, $port) = @_;

		say "A connection from $host:$port";

		my $id = $clientId++;

		my $w = AnyEvent::Handle->new(fh => $fh,
			on_error => sub {
		    		say "Bah, something bad happened with client $id ($host:$port)";
				delete $clients{$id};
			},
			on_eof => sub {
				say "Hm, client $id ($host:$port) went away";
				delete $clients{$id};
			},
		);
		$clients{$id} = $w;

		$w->push_write("Hello there!\r\n");
		$w->push_read(line => sub { client_read($_[0], $_[1], $_[2]) });
	};


	$cv->recv();
}
