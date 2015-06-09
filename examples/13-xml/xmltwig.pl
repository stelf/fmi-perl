#!/usr/bin/env perl

use strict;
use warnings;

use v5.012;

use XML::Twig;

my $fname = './nlwikimedia-20150425-pages-articles-multistream.xml';
my %c;

my $twig=XML::Twig->new(
	twig_roots => {
		'contributor/username' => sub {
			my ( $t, $elt ) = @_;
			exists $c{$elt->text} or $c{$elt->text} = 1 and say $elt->text ;
			$t->purge;
		}
	}
);

$twig->parsefile($fname);

<>
