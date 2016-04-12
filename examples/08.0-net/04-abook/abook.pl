#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use lib './lib';
use PPP::Abook qw/add_address remove_address list/;

use IO::Socket;


my %cmds = (
  add => \&add_address,
  remove => \&remove_address,
  list => \&list
);

sub handle_cmd {
  my ($op, @args) = @_;

  if (!exists $cmds{$op}) {
    return "ERR: invalid command";
  }

  $cmds{$op}->(@args);
}

sub parse {
  split /(?<!\\);/, $_[0];
}

sub conn_handler {
  my $server_sock = IO::Socket::INET->new(
    LocalAddr => 'localhost:7337',
    Proto => 'tcp',
    Listen => 1,
    ReuseAddr => 1,
  ) or die "Cannot create socket: $!\n";

  while (my $cmd_sock = $server_sock->accept()) { 
    my $data = <$cmd_sock>;
    $data =~ s/(\r\n|\n|\n\r)$//;
    say "[$data]";

    my @cmd = parse($data);
    my $resp = handle_cmd(@cmd);
    say $cmd_sock $resp;

    close $cmd_sock;
  }
}

conn_handler();
