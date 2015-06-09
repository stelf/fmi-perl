#!/usr/bin/perl

use strict;
use warnings;
use v5.012;

my $testString     =       " let me\tdo\tsome\tdancin' !!! ";

$testString     =~      /[\w\s]+/;
say "|$&|";

$testString     =~      /(\w+\t)/;
say "|$1|";

# (?=pattern)
# A zero-width positive look-ahead assertion
# istinno posterirorno twxrdenie s nuleva dxljina

$testString     =       " let me\tdo\tsome\tdancin' !!! ";
$testString     =~      /[\w\s]+/;
say "|$&|";

$testString     =~      /(\w+\t)/;
say "|$1|";

# (?=pattern)
# A zero-width positive look-ahead assertion
# istinno posterirorno twxrdenie s nuleva dxljina

$testString     =~      /(\w+(?=\t))/;
say "|$1|$&| << ! >>";

# (?!pattern)
# A zero-width negative look-ahead assertion
# neistinno posterirorno twxrdenie s nuleva dxljina

$testString     =~      /(\w+(?!\t))/;
say "|$1|$&| << ! >>";

$testString     =~      /(\w+(?!\s))/;
say "|$1|$&| << ! >>";

# (?<=pattern)
# A zero-width positive look-behind assertion
# istinno apriorno twxrdenie s nuleva dxljina

# (?<!pattern)
# A zero-width negative look-behind assertion
# istinno apriorno twxrdenie s nuleva dxljina

$testString     =~      /((?<=\t)\w+)/;
say "|$1|$&| << ! >>";

