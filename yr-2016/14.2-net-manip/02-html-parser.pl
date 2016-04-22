#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use LWP::UserAgent;
use HTML::Parser;


my $ua = LWP::UserAgent->new;
$ua->agent("MyApp/0.1 ");

my $req = HTTP::Request->new(POST => 'http://search.cpan.org/search');
$req->content_type('application/x-www-form-urlencoded');
$req->content('query=libwww&mode=dist');

my $res = $ua->request($req);

sub start {
  my ($tagname, $attr, $text) = @_;

  if ($tagname eq 'a') {
    my $href = $attr->{href};
    say "$tagname has [$href]";
  } elsif ($tagname eq 'script') {
    say "A script";
    say $text; #Dumper($attr);
  }
}

if ($res->is_success) {
  my $p = HTML::Parser->new(api_version => 3,
    start_h => [ \&start, "tagname, attr, text" ]);
  $p->report_tags(qw/a script/);

  $p->parse($res->content);
}
else {
  say $res->status_line, "\n";
}
