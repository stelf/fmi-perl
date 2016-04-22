#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use LWP::UserAgent;


my $ua = LWP::UserAgent->new;
$ua->agent("MyApp/0.1 ");

my $req = HTTP::Request->new(POST => 'http://search.cpan.org/search');
$req->content_type('application/x-www-form-urlencoded');
$req->content('query=libwww&mode=dist');

my $res = $ua->request($req);

if ($res->is_success) {
  say $res->content;
}
else {
  say $res->status_line, "\n";
}
