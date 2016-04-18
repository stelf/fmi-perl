package PPP::TestModule;

use strict;
use warnings;
use v5.014;

use Exporter qw/import/;

our @EXPORT_OK = qw/hi/;


sub hi {
  "hello";
}


1;
