#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use AnyEvent;
use AnyEvent::Handle;

sub http_get {
  my ($host, $uri, $cb) = @_;

  my ($response, $header, $body);
  my $cv = AnyEvent->condvar;

  my $handle; $handle = AnyEvent::Handle->new(
    connect => [$host => 'http'],
    on_error => sub {
      # Simplify error handling
      $cb->("HTTP/1.0 500 $!");
      $handle->destroy;
      $cv->send;
    },
    on_eof => sub {
      $cb->($response, $header, $body);
      $handle->destroy;
      $cv->send;
    }
  );

  # Push data to the write queue
  $handle->push_write("GET $uri HTTP/1.0 \015\012\015\012");

  # Push a read for a single line to the queue
  $handle->push_read(line => sub {
    my ($handle, $line) = @_;
    $response = $line;
  });
  
  # Push a read for a paragraph to the queue
  $handle->push_read(line => "\015\012\015\012", sub {
    my ($handle, $line) = @_;
    $header = $line;
  });

  # Push a read for all the remaining data
  $handle->on_read(sub {
    $body .= $_[0]->rbuf;
    $_[0]->rbuf = ""; # !empty the data buffer
  });

  $cv;
}

my $cv = http_get("www.google.com", "/", sub {
  my ($response, $header, $body) = @_;
 
  print "$header\n\n";
  print $response, "\n", $body;
});

$cv->recv;
