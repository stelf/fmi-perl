#!/usr/bin/env perl

use strict;
use warnings;
use v5.012;

use threads;
use threads::shared;

use URI;
use LWP::Simple qw/get/;
use Thread::Queue;
use HTML::LinkExtor;

length $ARGV[0] or die "please specify walker";
my $u = URI->new($ARGV[0]);
my $host:shared = shared_clone $u->host;

my $visited:shared = shared_clone {};
my $cnt:shared = 1;

my $q = Thread::Queue->new;
$q->enqueue($u->abs($host));

say 'start with', $u->abs($host);

sub walker {
    my $p = HTML::LinkExtor->new( sub {
        lock $visited;
        my($tag, %links) = @_;

        # we onyl need A (anchor) tags
        return if $tag !~ /a/i;

        foreach my $loc ( values %links ) {
            $loc =~ s/#.*$//;
            my $nu = URI->new($loc);

            ref ($nu) !~ /http|generic/ and next;

            if (ref($nu) =~ /generic/) {
                $nu = URI->new('http://'.$host.'/'.$nu);
            }

            # we need to stay on this domain
            $nu->host ne $host and next;
            # let's not visit twice
            # say 'enqueue ', $nu;
            exists $visited->{$nu->abs($host)} and next;
            $visited->{$nu->abs($host)}++;
            # all good? schedule for visit
            $q->enqueue($nu->abs($host));
        }
    });

    while ( $q->pending ) {
        $cnt++;
        my $url = $q->dequeue;
        say threads->tid, ': [', $q->pending, '] walking ', $url;
        my $c = get $url;
        defined $c and length $c and $p->parse($c);

        if ( threads->list(threads::running) < 8 ) {
            threads->create(\&walker);
        }
    }

}

threads->create(\&walker);

while ( threads->list(threads::running) ) {
    sleep 1;
}

$_->join foreach threads->list(threads::joinable);


say join "\n", keys %{$visited};
