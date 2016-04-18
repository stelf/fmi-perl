#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use FindBin;
use lib "$FindBin::Bin/lib";

use PPP::TestModule qw/hi/;

say PPP::TestModule::hi();
