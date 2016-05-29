#!/usr/bin/env perl

use forks;

use strict;
use warnings;
use v5.014;

use IO::Socket::INET;
use Thread::Queue;
use Data::Dumper;


my $q = Thread::Queue->new();
my $answerQ = Thread::Queue->new();

my %vars;

sub do_modify {
  my ($cli, $what, $how) = @_;
  return if !defined $what || !defined $how;

  $answerQ->enqueue("$cli At $cli");
  $answerQ->enqueue("$cli Before $vars{$what}") if defined $vars{$what};
  $vars{$what} = $how;
  $answerQ->enqueue("$cli After $vars{$what}");
}

sub do_show {
  my ($cli, $what) = @_;
  return if !defined $what;

  $answerQ->enqueue("$cli Undefined") and return
    if !defined $vars{$what};

  $answerQ->enqueue("$cli $vars{$what}");
}

my %cmds = (
  quit => \&do_quit,
  modify => \&do_modify,
  show => \&do_show,
);


my $pusher;
my @threads;
my %sockets;
$, = ' ';

my $server = IO::Socket::INET->new(
  LocalAddr => 'localhost:1337',
  Proto => 'tcp',
  Listen => 10,
  ReuseAddr => 1,
) or die "Could not create server: $!\n";

sub clean_up {
  for my $t (@threads) {
    $t->detach;
  }
  $pusher->detach;
  $q->end();
  say "terminated";
  exit 0;
}

$SIG{KILL} = \&clean_up;
$SIG{TERM} = \&clean_up;

# A single thread pushes things to the queue
$pusher = threads->new(sub {
  while (defined (my $it = $q->dequeue)) {
    say Dumper($it);
    $cmds{$it->{op}}->($it->{sock}, @{$it->{args}});
  }
});

while (my $cli = $server->accept()) {
  my $t = threads->new(sub {
    while (<$cli>) {
      chomp;

      my ($op, @args) = split ' ';
      say "[$op]";
      say "[@args]";
      say $cli 'bad input' and next
          if not exists $cmds{$op}; # !~ /(?:quit|modify)/;

      if ($op eq 'quit') {
        $cli->close;
        last;
      } else {
        $q->enqueue({
          sock => $cli->peerport,
          op => $op,
          args => [ @args ]
        });
      }
    }
  });

  my $t2 = threads->new(sub {
  })

  push @threads, $t;
}
