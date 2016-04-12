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
      or return "ERR";

    say $src "$name,$phone";
    return "OK";
  }

  open my $src, '<', $abook_name
    or return "ERR";

  my $copy_file = "$abook_name.new";
  open my $new, '>', $copy_file
    or return "ERR";

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

  return "OK";
}

sub list {
  open my $abook, '<', $abook_name
    or return "ERR";

  my @ret_list;
  while (<$abook>) {
    chomp;
    my ($name, @phones) = split /,/;

    push @ret_list, "$name => " . join ', ', @phones;
  }

  return "LIST ", join ';', @ret_list;
}

sub remove_address {
  if (!-f $abook_name) {
    # TODO: Maybe handle error
    return "ERR";
  }

  my ($name, $phone) = @_;

  open my $src, '<', $abook_name
    or return "ERR";

  my $tmp_file = "$abook_name.new";
  open my $tmp, '>', $tmp_file
    or return "ERR";

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

  return "OK";
}

1;
