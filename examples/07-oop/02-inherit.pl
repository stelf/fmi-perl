#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;


package LightSource {
  use Moose;

  has 'candle_power', 
    is => 'ro',
    isa => 'Int',
    default => 1;

  has 'enabled',
    is => 'ro',
    isa => 'Bool',
    default => 0,
    writer => '_set_enabled'; # private accessor

  sub light {
    my $self = shift;
    $self->_set_enabled(1);
  }

  sub extinguish {
    my $self = shift;
    $self->_set_enabled(0);
  }
}

# overriding
package LightSource::Cranky {
  use Carp 'carp';
  use Moose;

  extends 'LightSource';

  override light => sub {
    my $self = shift;

    carp "Can't light a lit source!" if $self->enabled;

    super();
  }

  override extinguish => sub {
    my $self = shift;

    carp "Can't extinguish unlit source!" if !$self->enabled;

    super();
  }
}

# Inherit attribs
package SuperCandle {
  use Moose;

  extends 'LightSource';

  has '+candle_power', default => 100;
}

# Inherit methods
package Glowstick {
  use Moose;

  extends 'LightSource';

  sub extinguish {}
}
