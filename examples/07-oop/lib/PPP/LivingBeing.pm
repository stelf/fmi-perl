package PPP::LivingBeing;

use Moose::Role;

has 'name' => (is => 'ro', isa => 'Str');

has 'birth_year' => (
  is => 'ro',
  isa => 'Int',
  default => sub { (localtime)[5] + 1900 }
);

sub age {
  my $self = shift;
  my $year = (localtime)[5] + 1900;

  return $year - $self->birth_year;
}

801;
