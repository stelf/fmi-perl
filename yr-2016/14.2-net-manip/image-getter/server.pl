#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use IO::Socket::INET;

my $server = IO::Socket::INET->new(
  LocalAddr => 'localhost:1337',
  Proto => 'tcp', 
  Listen => 2,
  ReuseAddr => 1
) or die "Could not create server: $!\n";

while (my $cli = $server->accept()) {
  my $cmd_line = <$cli>;
  chomp $cmd_line;

  say "got line: $cmd_line";

  close $cli and next
    if $cmd_line !~ /(xml|json)\s(\d+)/;
  my ($format, $length) = split / /, $cmd_line;

  say "got fmt, len: [$format, $length]";

  my $data;
  $cli->read($data, $length);

  my $out_length = length $data;

  say $cli "$format $out_length";
  print $cli $data;

  close $cli;
}
