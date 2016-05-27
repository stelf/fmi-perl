#!/usr/bin/env perl

use forks;
use forks::shared;

use strict;
use warnings;
use v5.014;

use IO::Socket::INET;


my %vars :shared;

sub do_quit {
  my $cli = shift;

  $cli->close and die 'close me';
}

sub do_modify {
  my ($cli, $what, $how) = @_;
  return if !defined $what || !defined $how;

  say $cli "At " . $cli->peerport;
  say $cli "Before $vars{$what}" if defined $vars{$what};
  $vars{$what} = $how;
  say $cli "After $vars{$what}";
}

sub do_show {
  my ($cli, $what) = @_;
  return if !defined $what;

  say $cli "Undefined" and return
    if !defined $vars{$what};

  say $cli $vars{$what};
}

my %cmds = (
  quit => \&do_quit,
  modify => \&do_modify,
  show => \&do_show,
);


my @threads;
$, = ' ';

my $server = IO::Socket::INET->new(
  LocalAddr => 'localhost:1337',
  Proto => 'tcp',
  Listen => 10,
  ReuseAddr => 1,
) or die "Could not create server: $!\n";

while (my $cli = $server->accept()) {
  my $t = threads->new(sub {
    while (<$cli>) {
      chomp;

      my ($op, @args) = split ' ';
      say "[$op]";
      say "[@args]";
      say $cli 'bad input' and next
          if not exists $cmds{$op}; # !~ /(?:quit|modify)/;

      eval { $cmds{$op}->($cli, @args); };
      if ($@ =~ /close me/) {
        last;
      }
    }
  });

  push @threads, $t;
}

for my $t (@threads) {
  $t->join;
}
