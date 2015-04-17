#!/usr/bin/perl

use Test::More tests => 18;

BEGIN { use_ok('Test::Comm', ':comm'); }

my $comm = comm_init();

#is ref $comm, 'HASH', 'comm_init() returned a hash reference';
#is join(' ', keys %{$comm}), 'lines', 'comm_init() only has a single "lines" member';
#is ref $comm->{lines}, 'HASH', 'comm->lines is a hashref';
#is scalar keys %{$comm->{lines}}, 0, 'comm->lines is empty';

is_deeply $comm,
    { lines => {} },
    'comm_init() returned an empty comm object';

is_deeply [ comm_encode_text($comm, '', 'foo') ],
    [ 'foo ' ],
    'encode an empty string';
is_deeply [ comm_encode_text($comm, 'bar', 'tag') ],
    [ 'tag bar' ],
    'encode a single line';
is_deeply [ comm_encode_text($comm, "bar\n\n\n", 'another') ],
    [ 'another bar' ],
    'encode a single line stripping the trailing newlines';
is_deeply [ comm_encode_text($comm, "foo\nbar", 'a') ],
    [ 'a-foo', 'a bar' ],
    'encode two lines';
is_deeply [ comm_encode_text($comm, "foo\n\nbar", 'a') ],
    [ 'a-foo', 'a-', 'a bar' ],
    'encode three lines including an empty one';
is_deeply [ comm_encode_text($comm, "foo\n\nbar\n\n\n", 'a') ],
    [ 'a-foo', 'a-', 'a bar' ],
    'encode three lines and strip the trailing newlines';

is_deeply [ comm_decode_line $comm, 'a line' ],
    ['a', 'line'],
    'decode a single line';

is_deeply [ comm_decode_line $comm, 'b-line' ],
    [],
    'decode - continuation';
is_deeply [ comm_decode_line $comm, 'b end of the line' ],
    ['b', "line\nend of the line"],
    'decode - end';

is_deeply [ comm_decode_line $comm, 'tag-more :)' ],
    [],
    'decode - 1/3';
is_deeply [ comm_decode_line $comm, 'tag-even more' ],
    [],
    'decode - 2/3';
is_deeply [ comm_decode_line $comm, 'tag and stuff' ],
    ['tag', "more :)\neven more\nand stuff"],
    'decode - 3/3';

is_deeply [ comm_decode_line $comm, 'b-line' ],
    [],
    'decode - continuation interrupted';
is_deeply [ comm_decode_line $comm, 'a line' ],
    ['a', 'line'],
    'decode a single interjected line';
is_deeply [ comm_decode_line $comm, 'b end of the line' ],
    ['b', "line\nend of the line"],
    'decode - end after an interruption';

eval { comm_decode_line $comm, "ahdh! moo" };
my $msg = $@;
ok defined $msg, 'decode - bail out on an invalid string';
