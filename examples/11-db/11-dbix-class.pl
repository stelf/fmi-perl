#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: 11-dbix-class.pl
#
#        USAGE: ./11-dbix-class.pl  
#
#  DESCRIPTION: a
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 04/24/2015 01:21:41 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use DBIx::Class::Loader;
 
my $loader = DBIx::Class::Loader->new(
   dsn       => "dbi:Pg:dbname=T1",
   user      => "postgres",
   password  => "12345678",
   namespace => "Data",
);

my $class = $loader->find_class('tblsecond'); # $class => Data::Film
my $obj = $class->retrieve(1);

