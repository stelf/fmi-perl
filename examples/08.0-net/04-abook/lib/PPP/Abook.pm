package PPP::Abook;

use strict;
use warnings;
use 5.014;

use Exporter;
use File::Copy;

our @ISA = qw/Exporter/;

our @EXPORT_OK = qw/add_address remove_address list/;


my $abook_name = 'abook.csv';

sub add_address {
  my ($name, $phone) = @_;

  if (!-f $abook_name) {
    open my $src, '>', $abook_name
      or die ("Cannot open address book file: $abook_name;\n $!");

    say $src "$name,$phone";
    return;
  }

  open my $src, '<', $abook_name
    or die ("Cannot open address book file: $abook_name;\n $!");

  my $copy_file = "$abook_name.new";
  open my $new, '>', $copy_file
    or die ("Cannot open file for copying: $copy_file;\n $!");

  my $is_added;

  while (<$src>) {
    chomp;
    /([^,]+)/;

    say $new $_ and next
        unless $1 eq $name;

    say $new "$_,$phone";
    $is_added = 1;
  }

  if (!defined $is_added) {
    say $new "$name,$phone";
  }

  close $src;
  close $new;

  move $copy_file, $abook_name;
}

sub list {
  open my $abook, '<', $abook_name
    or die ("Cannot open books file: $abook_name; $!");

  while (<$abook>) {
    chomp;
    my ($name, @phones) = split /,/;

    say "$name => ", join ', ', @phones;
  }
}

sub remove_address {
  if (!-f $abook_name) {
    # TODO: Maybe handle error
    return;
  }

  my ($name, $phone) = @_;

  open my $src, '<', $abook_name
    or die "Cannot open $abook_name; $!";

  my $tmp_file = "$abook_name.new";
  open my $tmp, '>', $tmp_file
    or die "Cannot open $tmp_file; $!";

  while (<$src>) {
    chomp and /([^,]+),(.*)/;

    if ($name eq $1) {
      if (defined $phone) {
        my @nums = split /,/, $2;
        my @to_leave;

        for my $num (@nums) {
          if ($num ne $phone) {
            push @to_leave, $num;
          }
        }

        say $tmp join ',', ($name, @to_leave);
      }

      next;
    }

    say $tmp $_;
  }

  move $tmp_file, $abook_name;
}

0;
