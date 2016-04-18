#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


package Dog {
  sub new {
    my $class = shift;
    my $self = shift;

    $self ||= {};

    bless $self, $class;
    return $self;
  }

  sub bark {
    my $self = shift;
    say $self->{bark_sound};
  }
}

package Gucci {
  use base qw/Dog/;

  sub flash {
    say "I'm fabulous";
  }
}


my $shy_doggy = Dog->new({ bark_sound => 'wimp' });
$shy_doggy->bark();

$shy_doggy->{bark_sound} = 'jauf';
$shy_doggy->bark();

if (!$shy_doggy->can('meow')) {
  say "doggy can't 'meow'";
}

say $shy_doggy->can('bark');

my $fam_doggy = Gucci->new({ bark_sound => 'glitter' });

$fam_doggy->bark();
$fam_doggy->flash();
