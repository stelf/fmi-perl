#!/usr/bin/perl

use warnings;
use strict;
use v5.012;

use Template;
use HTTP::Server::Simple;
use HTTP::Server::Simple::CGI;

package PPP::DemoServer;
use base qw(HTTP::Server::Simple::CGI);

no strict 'refs';

my %ttype = (
    '/'	=> 'html.out.tt',
    '/plain' => 'plain.out.tt',
    '/html' => 'html.out.tt',
);

my %htype = (
    '/'	=> 'text/html',
    '/plain' => 'text/plain',
    '/html' => 'text/html',
);

sub handle_request {
    my ($self, $cgi) = @_;
    my $ttvars = {};

    print "HTTP/1.0 200 OK\r\n";
    print $cgi->header($htype{$cgi->path_info()});

    $cgi->import_names('PPP::DemoServer::CGI');

    $ttvars->{cvars}  = { 
        map {
            $_ => ${ $PPP::DemoServer::CGI::{$_} }
        } keys %PPP::DemoServer::CGI:: 
    };

    $ttvars->{aparam} = [ $cgi->param ];

    my $tt = Template->new({
            INCLUDE_PATH => 'templates/',
        }) || die "$Template::ERROR\n";

    my $tname = $ttype{$cgi->path_info()};
    $tname ||= 'html.out.tt';

    print $tt->process($tname, $ttvars);
}

package main;

my $server = PPP::DemoServer->new();
$server->run();


