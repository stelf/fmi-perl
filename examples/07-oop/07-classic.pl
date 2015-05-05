#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: 08-classic.pl
#
#        USAGE: ./08-classic.pl  
#
#  DESCRIPTION: classic OOP example
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 04/17/2015 12:39:35 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

package MyTest;

sub test { 
    my $self = shift;

    say $self->{me};
}

sub whatami { 
    say ref $_[0];
}

sub new {
    my $proto = shift;
    my $self = shift;

    $self ||= {};

    bless $self, $proto;

    return $self;
}

package MyTestInherit;
use base qw/MyTest/;


package main;

my $s = MyTest->new( { 'me' => 'I am scalar' } );
my $si = MyTestInherit->new( { 'me' => 'I am something else' } );

$s->test;

$s->whatami;
$si->whatami;

if ( $s->can('whatami') ) { 
    say ref $s, ' can do method ->whatami';
}

