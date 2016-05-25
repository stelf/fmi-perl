#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use Dancer;
use List::Util qw/reduce/;


use Log::Log4perl;
Log::Log4perl->init("etc/log.conf"); # 'HUP'


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

sub status_forbidden {
  my $msg = shift;
  $logger->info($msg) and 
    status 'Forbidden' and
      return $msg;
}

sub check_params {
  param('fname') or 
    return "param `fname` expected";

  param('fname') =~ /\.sum$/ or
    return "file extension should be `.sum`";

  param('numbers') or
    return "param `numbers` expected";

  return undef;
}

prefix '/fs' => sub {
  post '/create-file' => sub {
    $logger->info("In /create-file");
    my $check = check_params();
    if (defined $check) {
      return status_forbidden($check);
    }

    open (my $fh, '>', param('fname')) or
      return status_forbidden("can't open file");

    print $fh param('numbers');

    return 'Created'; 
  };

  get qr{/sum/(.*\.sum$)} => sub {
    my ($fname) = splat;

    open (my $fh, '<', $fname)
      or status 'Forbidden' and return;

    my @nums;
    while (<$fh>) {
      push @nums, split ',';
    }

    return reduce { $a + $b } @nums;
  };

  put '/update-file' => sub {
    $logger->info("In /update-file");
    my $check = check_params();
    if (defined $check) {
      return status_forbidden($check);
    }

    open (my $fh, '>>', param('fname')) or
      return status_forbidden("can't open file");

    print $fh "\n" . param('numbers');

    return 'Updated';
  };
};

dance;
