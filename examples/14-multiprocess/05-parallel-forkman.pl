#!/usr/bin/perl

use strict;
use warnings;
use v5.012;

use LWP::Simple;
use Parallel::ForkManager;
 
my @links=(
  ["http://25.media.tumblr.com/8756e148e434f909f69cc5c7f349d3d3/tumblr_mxqvlifUXL1s397qyo1_500.jpg","cat1.jpg"],
  ["http://25.media.tumblr.com/4733175ac264681532ed22e8504b3618/tumblr_mxqvlifUXL1s397qyo2_500.jpg","cat2.jpg"],
  ["http://25.media.tumblr.com/a030ce2b1c69d696c55634b8ad84df85/tumblr_mh7guqtfbC1qb7fhto1_400.jpg","dog1.jpg"],
  ["http://25.media.tumblr.com/tumblr_lrlflin2IL1qb7fhto1_1280.jpg", "dog2.jpg"],
  ["http://25.media.tumblr.com/17zvncVT7pqxew6uFRQKEvwpo1_500.jpg", "something.jpg"],
  ["http://0.tqn.com/d/cats/1/7/1/s/2/Jamie500x375.jpg", "jamie.jpg"]
);
 
mkdir "tmpimg";
chdir "tmpimg";

# Max 3 processes for parallel download
my $pm = Parallel::ForkManager->new(3);
 
foreach my $linkarray (@links) {
	$pm->start and next; # do the fork

	my ($link, $fn) = @$linkarray;
	say sprintf "getting %s from %s", $link, $fn;

	warn "Cannot get $fn from $link"
		if getstore($link, $fn) != RC_OK;

	$pm->finish; # do the exit in the child process
}

$pm->wait_all_children;
