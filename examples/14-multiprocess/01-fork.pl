#!/usr/bin/env perl

use strict;
use v5.012;
use warnings;

my $pid = fork;

my @arr = 1..1000;

# this function reads from STDIN
# it is generally considered a *bad* idea to
# read from STDIN from more than one process

sub readsome {
    my $line = <>;

    if (!defined($line)) {
        die "Could not read anything from the standard input: $!\n";
    } else {
        say "Got a line in $_[0]: $line";
    }
}

# now, let's do some experiments
if ( !defined $pid ) {
    die "Could not fork: $!\n";
} elsif ( $pid != 0 ) {
    # returns process id in the parent
    say 'i have a child process with pid ', $pid;
    readsome 'parent';

    waitpid $pid, 0;
} else {
    # returns zero, but we have gettpid to get parent process id
    say 'im child process with parent ', getppid;
    say 'i have @arr var with ', scalar (@arr), ' elements';

    readsome 'child';
    say 'sleeping some more seconds';
    sleep 3;
}

