#!/usr/bin/env perl

use strict;
use warnings;
use v5.016;

BEGIN {
	use FindBin;
	my $etc =  $FindBin::Bin;

	require Log::Log4perl;
	Log::Log4perl::init('logging.conf');
}


package Example;
use Moose;

use Log::Log4perl qw/:easy/;

has prop => (
	isa => 'Int',
	is => 'rw',
);

has trop => (
	isa => 'Str',
	is => 'rw',
);

sub met {
	my $logdtl = Log::Log4perl->get_logger('detailed');
	my $logger = Log::Log4perl->get_logger('demo');

	$logdtl->debug("everything is fine, i just need s.o. to talk to");
	$logger->warn("beware!");
	$logdtl->info("lemme share this, no worries");
#	$logger->fatal("you're a deadman");
	DEBUG('baw!');
}

package main;

my $logger = Log::Log4perl->get_logger('detailed.'.__PACKAGE__);

$logger->info('app is alive');

my $e = Example->new;
$e->met;



