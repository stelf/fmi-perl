#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use Dancer;
use List::Util qw/reduce/;

use Log::Log4perl;
Log::Log4perl->init_and_watch("etc/log.conf", 20); # 'HUP'

my $logger = Log::Log4perl->get_logger();


get '/sum/:one/:two' => sub {
  $logger->info("In /sub/:one/:two");
  return param('one') + param('two');
};

get '/sum-many/:numbers/:initial?' => sub {
  $logger->info("In /sum-many/:numbers/:initial?");
  my @nums = split ',', param('numbers');
  my $initial = param('initial') // 0;
  return $initial + reduce { $a + $b } @nums;
};

prefix '/fs' => sub {
  post '/create-file' => sub {
    param('fname') or 
      status 'Forbidden' and return "param `fname` expected";

    param('fname') =~ /\.sum$/ or
      status 'Forbidden' and return "file extension should be `.sum`";

    param('numbers') or
      status 'Forbidden' and return "param `numbers` expected";

    open (my $fh, '>', param('fname'))
      or status 'Forbidden' and return;

    print $fh param('numbers');

    return 'Created'; 
  };

  get qr{/sum/(.*\.sum)} => sub {
    my ($fname) = splat;

    open (my $fh, '<', $fname)
      or status 'Forbidden' and return;

    my @nums;
    while (<$fh>) {
      push @nums, split ',';
    }

    return reduce { $a + $b } @nums;
  };
};

dance;
