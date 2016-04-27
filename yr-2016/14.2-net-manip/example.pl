#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use local::lib 'local/lib';

use LWP::UserAgent;
use HTML::LinkExtor;


my @imgs = ();
sub cb {
  my ($tag, %attr) = @_;
  return unless $tag eq "img";
 
  push @imgs, values %attr;
}


my $ua = LWP::UserAgent->new;
my $url = "http://9gag.com";
my $res = $ua->request(HTTP::Request->new(GET => $url));

if ($res->is_success) {
  my $p = HTML::LinkExtor->new(\&cb);
  $p->parse($res->content);
}

$, = "]\n[";
say "Images:";
print "[";
say @imgs;
print "]";
