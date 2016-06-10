#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use AnyEvent;
use AnyEvent::Socket;

sub finger {
  my ($user, $host) = @_;

  my $cv = AnyEvent->condvar;
  
  tcp_connect $host, 'finger', sub {
    my ($fh) = @_
      or return $cv->send;

    syswrite $fh, "$user\015\012";

    my $response;

    my $read_watcher; $read_watcher = AnyEvent->io(
      fh => $fh,
      poll => "r",
      cb => sub {
        my $len = sysread $fh, $response, 1024, length $response;

        if ($len <= 0) {
          undef $read_watcher;
          $cv->send($response);
        }
      }
    );
  };

  $cv;
}

my $f1 = finger("kuriyama", "freebsd.org");
my $f2 = finger("icculus?listarchives=1", "icculus.org");
my $f3 = finger("mikachu", "icculus.org");
 
print "kuriyama's gpg key\n"    , $f1->recv, "\n";
print "icculus' plan archive\n" , $f2->recv, "\n";
print "mikachu's plan zomgn\n"  , $f3->recv, "\n";
