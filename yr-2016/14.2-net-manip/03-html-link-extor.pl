#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use LWP::UserAgent;
use HTML::LinkExtor;
use URI::URL;


my @imgs = ();
sub cb {
  my ($tag, %attr) = @_;
  return if $tag ne 'img';

  push @imgs, values %attr;
}

my $p = HTML::LinkExtor->new(\&cb);


my $ua = LWP::UserAgent->new;
my $url = "http://www.9gag.com";
my $res = $ua->request(HTTP::Request->new(GET => $url));

if ($res->is_success) {
  $p->parse($res->content);
}

say "Non abs:";
$, = "]\n[";
print "[";
say @imgs;

# Make URLs absolute
my $base = $res->base;
say "\nBase [$base]";

@imgs = map { url($_, $base)->abs; } @imgs;
print "[";
say @imgs;
