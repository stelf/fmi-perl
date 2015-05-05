#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: mysync.pl
#
#        USAGE: ./mysync.pl  
#
#  DESCRIPTION: sync two dirs while traversing them
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: stelf
# ORGANIZATION: Practical Perl Programming at @FMI
#      VERSION: 1.0
#      CREATED: 04/17/2015 10:26:10 AM
#===============================================================================

use strict;
use warnings;
use utf8;

use Set::Functional qw/difference_by/;
use File::Copy qw/copy/;
use File::Find;
use File::Compare;

use v5.012;

use experimental qw/switch autoderef/;

my $src = '/home/stelf/tmp/s';
my $dst = '/home/stelf/tmp/d';

sub want {
   return if /^\./;

   my $sfile = $File::Find::dir.'/'.$_;
   my $dfile = $dst.(substr $File::Find::dir, length $src).'/'.$_;

   say 'process: ', $sfile;

   given ( $sfile ) {
       when (-f) { 
           if (compare $sfile, $dfile) {
               say 'copy: ', $sfile;
               copy $sfile, $dfile;
           }
       }

       when (-d) {
            mkdir $dfile unless -e $dfile;
       }
    }
}

sub pproc { 
   say 'finalize: ', $File::Find::dir;

   my $sdir = $File::Find::dir;
   my $ddir = $dst.(substr $File::Find::dir, length $src);

   my @slist = map { [ substr ($_, length($src) + 1), $_ ] } <$sdir/*>;
   my @dlist = map { [ substr ($_, length($dst) + 1), $_ ] } <$ddir/*>;
    
   foreach my $dfile ( difference_by { $_->[0] } [@dlist], [@slist] ) {
       say 'removing: ', $dfile->[1];
       -f $dfile->[1] and unlink $dfile->[1] ;
       -d $dfile->[1] and rmdir $dfile->[1] ;
   }
}

find( { wanted => \&want, postprocess => \&pproc } , $src );

