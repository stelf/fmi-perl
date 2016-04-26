#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use local::lib 'local';

use IO::Socket::INET;
use JSON::XS;
use XML::Parser;
use XML::Generator;


my $usage =<<USAGE
  perl client.pl <format> <link> [<links>]

    <format>: `xml` or `json`
    <link>: valid URI of a web page
USAGE
;


print $usage and exit
  if scalar @ARGV < 2;

my $format = shift @ARGV;
print $usage and exit
  if !defined $format || $format !~ /xml|json/;

my @links = @ARGV;


sub ig_send {
  my $ig_proto = shift;

  my $sock = IO::Socket::INET->new(
    PeerAddr => 'localhost:1337',
    Proto => 'tcp',
  ) or die "Could not create client socket: $!\n";

  say $sock $ig_proto;

  $sock;
}

sub ig_receive {
  my $sock = shift;

  # Read the header
  # <format> <size>
  my $ig_header = <$sock>;
  return if $ig_header !~ /\A(json|xml)\s(\d+)\Z/;
  my ($format, $length) = split / /, $ig_header;

  # Read the data
  my $ig_data;
  $sock->read($ig_data, $length);

  $ig_data;
}

sub xml_generate {
  my @links = @_;

  my $gen = XML::Generator->new(':pretty');

  my $xml = "<links>\n";
  for (@links) {
    $xml .= $gen->link({}, $_);
  }
  $xml .= "</links>\n";

  $xml = sprintf "%s %d\n%s", 
    "xml", length $xml, $xml;

  $xml;
}

sub do_xml {
  my @links = @_;

  my $xml = xml_generate(@links);
  my $sock = ig_send $xml;
  my $msg = ig_receive $sock;

  say $msg;

  close $sock;
}

sub json_generate {
  my @links = @_;
 
  my $json = encode_json \@links;

  $json = sprintf "%s %d\n%s",
    "json", length $json, $json;

  $json;
}

sub do_json {
  my @links = @_;

  my $json = json_generate(@links);
  my $sock = ig_send $json;
  my $msg = ig_receive $sock;

  say $msg;

  close $sock;
}


my %cmds = (
  xml => \&do_xml,
  json => \&do_json,
);

$cmds{$format}->(@links);
