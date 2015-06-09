#!/usr/bin/env perl

use strict;
use warnings;

use v5.012;

use XML::LibXML;
use File::Slurp qw/read_file/;

my $fname = './nlwikimedia-20150425-pages-articles-multistream.xml';

my $res = read_file($fname);
my $dom = XML::LibXML->load_xml(string => $res);

foreach my $elem ( @{ $dom->documentElement()->find("//*[name()='contributor']/*[name()='username']")} ) {
	defined $elem and
		say $elem->firstChild()->toString();
}






