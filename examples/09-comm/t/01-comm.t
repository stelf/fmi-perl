#!/usr/bin/perl

use Test::More tests => 7;

BEGIN { use_ok('Test::Comm', ':comm'); }

my $comm = comm_init();

#is ref $comm, 'HASH', 'comm_init() returned a hash reference';
#is join(' ', keys %{$comm}), 'lines', 'comm_init() only has a single "lines" member';
#is ref $comm->{lines}, 'HASH', 'comm->lines is a hashref';
#is scalar keys %{$comm->{lines}}, 0, 'comm->lines is empty';

is_deeply $comm,
    { lines => {} },
    'comm_init() returned an empty comm object';

is_deeply [ comm_encode_text($comm, 'bar', 'tag') ],
    [ 'tag bar' ];
is_deeply [ comm_encode_text($comm, 'bar\n\n\n', 'another') ],
    [ 'another bar' ];
is_deeply [ comm_encode_text($comm, 'foo\nbar', 'a') ],
    [ 'a-foo', 'a bar' ];
is_deeply [ comm_encode_text($comm, 'foo\n\nbar', 'a') ],
    [ 'a-foo', 'a-', 'a bar' ];
is_deeply [ comm_encode_text($comm, 'foo\n\nbar\n\n\n', 'a') ],
    [ 'a-foo', 'a-', 'a bar' ];
