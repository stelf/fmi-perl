package PPP::LightSource {
  use Moose;

  has candle_power => (is => 'ro', isa => 'Int', default => 1);
  has enabled => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
    writer => '_set_enabled'
  );

  sub light {
    my $self = shift;
    $self->_set_enabled(1);
  }

  sub extinguish {
    my $self = shift;
    $self->_set_enabled(0);
  }
}

package PPP::LightSourceCranky {
  use Carp;
  use Moose;

  extends qw/PPP::LightSource/;

  override light => sub {
    my $self = shift;

    carp "Can't light a lit source" 
      if $self->enabled;

    super();
  };

  override extinguish => sub {
    my $self = shift;

    carp "Can't extinguish an unlit source"
      if !$self->enabled;

    super();
  };
}

package PPP::SuperCandle {
  use Moose;

  extends qw/PPP::LightSource/;

  has 'candle_power', is => 'ro', isa => 'Int', default => 100;
}

package PPP::Glowstick {
  use Moose;

  extends qw/PPP::LightSource/;

  sub extinguish {};
}

1;
