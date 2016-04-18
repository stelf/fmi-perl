package PPP::Cat;

use PPP::LivingBeing;
use Moose;

with qw/PPP::LivingBeing/;

has 'diet' => (is => 'rw', isa => 'Str');

sub play_with_ppl {
  print "Meow! Feed me.\n";
}

sub play_with_mice {
  my $self = shift;
  my $mouse = shift;

  print "Bad mouse: $mouse\n";
}

1;
