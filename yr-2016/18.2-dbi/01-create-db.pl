#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use DBI;

my $dbfile = "sample.db";

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile",
  "", "", # <username> and <pass> not relevant for SQLite
  {
    PrintError => 0,
    RaiseError => 1,
    AutoCommit => 3
  });

=cut
my $create_tbl = <<'END_CREATE';
CREATE TABLE people (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100),
  lname VARCHAR(100),
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(20)
)
END_CREATE

$dbh->do($create_tbl);

# Fill some records
for (1..2) {
  say "First name: ";
  my $fname = <STDIN>;
  say "Last name: ";
  my $lname = <STDIN>;
  say "email: ";
  my $email = <STDIN>;

  # Use single-quotes in order not to insert raw user input
  $dbh->do('INSERT INTO people (fname, lname, email) VALUES (?, ?, ?)',
    undef,
    $fname, $lname, $email);
}
=cut


# Find some info
my $sql_length_names = <<'END_QUERY';
  SELECT fname, lname, email
  FROM people
  WHERE LENGTH(fname) < ?
END_QUERY

my $sth = $dbh->prepare($sql_length_names);
$sth->execute(5);

while (my @row = $sth->fetchrow_array) {
  say "$row[0] $row[1] has a short name";
}

$sth->execute(10);

while (my $row = $sth->fetchrow_hashref) {
  say "$row->{fname} $row->{lname} has a long name";
}


# Set passwords for ppl with short names
my $password = 'shorty';

$dbh->do('UPDATE people SET password = ? WHERE LENGTH(fname) < 5',
  undef,
  $password);

# Get people with passwords
my $sql_with_pass = <<'END_QUERY';
  SELECT fname, lname, email
  FROM people
  WHERE password IS NOT NULL
END_QUERY

my $sth2 = $dbh->prepare($sql_with_pass);

$sth2->execute();

while (my @row = $sth2->fetchrow_array) {
  say "$row[0] $row[1] has a password";
}


$dbh->disconnect;
