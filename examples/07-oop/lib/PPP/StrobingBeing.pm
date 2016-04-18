package PPP::StrobingBeing;

use Moose::Role;

has 'interval' => (is => 'ro', isa => 'Int');

sub strobe {
  my $self = shift;

  return ('*', $self->interval);
}

0xDEADBEEF;
