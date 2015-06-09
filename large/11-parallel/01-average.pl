#!/usr/bin/env perl

use threads;
use Thread::Queue;
use IO::Scalar;
use List::Util qw/sum/;
use IO::Handle qw();  # For autoflush
STDOUT->autoflush(1);

use warnings;
use strict;
use v5.012;

say 'program begins!';

my $debug = 0;
my $q = Thread::Queue->new;
my $r = Thread::Queue->new;

# generates 1k chunks
sub gendata {
    my $data = shift;
    say 'generate 1M data';
    $$data = pack 'C*', map {
        int rand 100
    } (1..1024);
}

# pumps 1024*1024 1k chunks

sub pump {
    my $res;
    say 'pump: start';
#    my $data;
#    gendata \$data;
#    my $SH = new IO::Scalar \$data;

#   while ( read $SH, $res, 1024 ) {

    for (my $i=0; $i < 8192; $i++) {
        $r->pending > 32 && redo;
        $res = pack 'C*', map { rand 255 } 1..1024;
        $debug and say 'pump: sending ', length $res;
        $q->enqueue($res);
    }

    $q->end;
    say 'pump: end';
}


sub chunker {
    say 'chunker: start';
    my $chunk;
    while ( defined ($chunk = $q->dequeue) ) {
        $debug and say 'chunker: got chunk sized ',  length $chunk;
        my @nums = unpack 'C*', $chunk;
        $debug and say 'chunker: cur avg is : '.(sum (@nums) / @nums);
        $r->enqueue( sum (@nums) / @nums );
    }

    say 'chunker: end';
}

sub res {
    say 'res: start';
    my (@e, $num);
    while (defined ($num = $r->dequeue)) {
#        @e % 1024 or say '.';
        $debug and say 'res: got ', $num;
        push @e, $num;
    }

    $debug and say 'res: end';
    @e and say sum (@e) / @e;
}

my $rt = threads->create( \&res ),

# more threads will not result in gained execution
# because essentially all effort goes into passing
# data around

my @th = (
    threads->create( \&chunker ),
    threads->create( \&chunker ),
    threads->create( \&chunker ),
    threads->create( \&chunker ),
    threads->create( \&chunker ),
    threads->create( \&chunker ),
    threads->create( \&chunker ),
    threads->create( \&chunker ),
    threads->create( \&pump ),
);

$_->join foreach (@th);
$r->end;
$rt->join;
