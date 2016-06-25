#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;

use JSON::XS; # с този модул ще четем входните файлове
use Path::Tiny; # с този модул ще си помагаме при манипулацията на файлове


my $usage =<<EOF
  Използване ./03-json-to-object.pl <вход> <изход>
EOF
;

say $usage and exit 
  if @ARGV < 2;


my ($input, $output) = @ARGV;

# не бихме могли да генерираме клас без да имаме входящ файл
if (!-f $input) {
  say "Не можах да намеря файла [$input]" and exit;
}


# прочитаме входящия файл
my $class_json = decode_json(path($input)->slurp);
# създаваме изходния, ако няма такъв
if (!-f $output) {
  path($output)->touchpath;
}


# 
# Следващите редове представляват главната функционалност на програмата.
# В три списъка събираме трите части на нашия файл -- заглавната, в която
# добавяме името на пакета и модулите, които ще използваме; частта със
# зависимостите, в която стоят другите класове, от които модулът ни зависи;
# и частта, в която дефинираме нашия клас.
#
# Това разделение е нужно за да можем лесно да добавяме парчета код на
# различни места в резултатния файл.  Като цяло, това решение си има проблеми,
# които биха могли да се решат с използването на асоциативен списък за
# предоставянето на повече контекст около отделните части на файла.  Например,
# в 03-inputs/person-2.json, Person зависи от Home и в генерацията на модула
# Home трябва да се запише преди Person.  Това обаче няма как да се разбере от
# поредността на декларация във входящия файл, защото в Perl асоциативните
# списъци не гарантират подредба на елементите си.
my %modules = %$class_json;
my @header_lines;
my @dependencies_lines;
my @class_lines;
# Минаваме модул по модул и генерираме файла.
for my $class (keys %modules) {
  push @header_lines, "package $class;\n";
  push @header_lines, "use Moose;\n";

  # След заглавната част, почваме да описваме същността на класа, неговите
  # свойства и методи.
  my %props = %{$modules{$class}};
  for my $prop_name (keys %props) {
    my $prop_type = $props{$prop_name}->{type};
    my $prop_access = $props{$prop_name}->{access};
    push @class_lines, "has '$prop_name' => (is => '$prop_access', isa => '$prop_type');\n";

    # Ако свойството не е тип, дефиниран от Moose, значи е клас, от който
    # зависим.  Тъй че, добавяме го в частта със зависимостите.
    if ($prop_type !~ /(String|Int|Bool|Double)/) {
      push @dependencies_lines, "use $prop_type;\n";
    }
  }

  # Накрая всичкото това се добавя в изходния файл.
  my @module_lines = (@header_lines, @dependencies_lines, @class_lines);
  push @module_lines, "1;\n";
  path($output)->append(@module_lines);

  # Продължаваме със следващия модул начисто.
  @header_lines = ();
  @dependencies_lines = ();
  @class_lines = ();
}

say "Конвертиране, приключено.";
