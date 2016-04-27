#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use local::lib 'local';

use IO::Socket::INET;
use JSON::XS;
use XML::Parser;
use XML::Generator;


#
# Parse the request
sub parse_xml {
  my $xml = shift;

  my @links;

  my $xml_parser = XML::Parser->new(Handlers => {
    Char => sub {
      my ($expat, $link) = @_;
      if ($expat->current_element() eq 'link' && defined $link) {
        push @links, $link;
      }
    }
  });

  $xml_parser->parse($xml);

  push @links, undef
    if scalar @links == 0;

  return @links;
}

sub parse_json {
  my $json = shift;

  my $data = decode_json $json;

  return @$data;
}

my %parsers = (
  xml => \&parse_xml,
  json => \&parse_json
);

sub parse_request {
  my $sock = shift;

  my $ig_header = <$sock>;
  chomp $ig_header;

  return undef 
    if $ig_header !~ /\A(xml|json)\s(\d+)\Z/;

  my ($format, $length) = split / /, $ig_header;

  my $ig_data;
  $sock->read($ig_data, $length);

  my @links = $parsers{$format}->($ig_data);

  ($format, @links);
}

#
# Get the pictures
sub crawl_links {
  my @links = @_;

  my @pics = @links;
  @pics;
}

#
# Generating response
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

sub json_generate {
  my @links = @_;
 
  my $json = encode_json \@links;

  $json = sprintf "%s %d\n%s",
    "json", length $json, $json;

  $json;
}

my %generators = (
  xml => \&xml_generate,
  json => \&json_generate
);

sub send_response {
  my ($cli, $format, @pics) = @_;

  my $ig_msg = $generators{$format}->(@pics);

  say $cli $ig_msg;
}


#
# Main loop
my $server = IO::Socket::INET->new(
  LocalAddr => 'localhost:1337',
  Proto => 'tcp', 
  Listen => 2,
  ReuseAddr => 1
) or die "Could not create server: $!\n";

while (my $cli = $server->accept()) {
  my ($format, @links) = parse_request($cli);
  if (scalar @links > 0) {
    my @pics = crawl_links(@links);
    send_response($cli, $format, @pics);
  }

  close $cli;
}
