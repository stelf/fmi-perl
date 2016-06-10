#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use AnyEvent;
use AnyEvent::Handle;

use Data::Dumper;

sub http_get {
  my ($proto, $host, $uri, $cb) = @_;

  my ($response, $header, $body);

  my $cv = AnyEvent->condvar;

  my %conn_params = (
    connect => [$host => 'http']
  );

  if ($proto eq "https") {
    my %conn_params = (
      connect => [$host => 'https'],
      tls => "connect"
    );
  }

  say Dumper(%conn_params);

  my $handle; $handle = AnyEvent::Handle->new(
    %conn_params,
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

my $cv = http_get("http", "www.google.com", "/", sub {
  my ($response, $header, $body) = @_;
 
  print "$header\n\n" if $header;
  print $response, "\n";
  print $body if $body;
});

$cv->recv;
