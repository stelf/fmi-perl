#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: local.pl
#
#        USAGE: ./local.pl  
#
#  DESCRIPTION: my vs local 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/13/2015 11:54:17 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.012;

# our - global in respect to the file (and package)
# my - lexical in respect to closure {} 
# local - save the state of the var until end of scope { }
# state - static value is preserved in consequent calls

sub func {
    say;
    $_ = <STDIN>;
    say;
}

$_ = 'LA';

say;            # say LA

{
    local $_;
   
    $_ .= 'RO';
    say;     # say RO
    func;
    say;
}

say;    # say LA

{   
    $_ .= 'DEE';
    say;    # say LADEE

}

say;            # say LADEE

