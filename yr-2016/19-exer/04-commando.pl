#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use AnyEvent;
use AnyEvent::Handle;
use AnyEvent::Socket;
use List::Util qw/reduce/;


# Източваме изхода на всеки байт за да можем в реално време да виждаме
# взаимодействието ни с програмата.  Вижте perldoc perlvar.
$| = 1;

#
# Клиентски операции
sub add {
  reduce { $a + $b } @_;
}

sub my_print {
  join ' ', @_;
}

my %client_ops = (
  add => \&add,
  print => \&my_print
);


#
# Частта от програмата, която си говори с клиентите.  Създаваме сървър на порт
# 1337 и на всяка нова връзка създаваме асинхронен handle, от който четем
# данни.
# В connections пазим текущите връзки към нас, защото иначе GC на Perl ще ги
# изчисти от паметта и съответно затвори.
my %connections;
sub create_server {
  tcp_server(undef, 1337, sub {
    my ($fh, $host, $port) = @_;

    say "Връзка от $host:$port...";
    my $handle; $handle = AnyEvent::Handle->new(
      fh => $fh,
      poll => 'r',
      on_read => sub {
        my ($self) = @_;
        # Абонираме се за четене на редове от сокета.
        $self->push_read(line => sub {
          my (undef, $line) = @_;
          chomp $line;
          my ($cmd, @args) = split / /, $line; # Парсваме команда.

          # Ако тя е 'bye', ще затворим сокета.
          if ($cmd eq "bye") {
            close $self->fh;
            return;
          }

          # Проверяваме дали знаем за тази команда.
          if (!exists ($client_ops{$cmd})) {
            $self->push_write("Не познавам тази команда [$cmd]...\n");
            return;
          }

          # Ако знаем, изпълняваме я и добавяме резултата ѝ в опашката за
          # писане.
          my $res = $client_ops{$cmd}->(@args);
          $self->push_write("$res\n");
        });
      }, on_eof => sub {
        my ($hdl) = @_;
        $hdl->destroy;
      }
    );

    $connections{$handle} = $handle;
  });
}

my $serv = create_server();

#
# Потребителски операции
sub do_stop {
  # do_stop спира сървъра като просто прави undef на $serv и на %connections
  say "Спирам...";
  undef $serv;
  undef %connections;
}

sub do_start {
  # do_start създава нов сървър, ако нямаме такъв
  say "Тръгвам...";
  if (!defined $serv) {
    $serv = create_server();
  }
}

sub do_restart {
  # Спираме и пускаме отново сървъра
  say "Рестартирам се...";
  do_stop();
  do_start();
}

sub do_exit {
  say "Чао...";
  exit;
}

my %user_ops = (
  stop => \&do_stop,
  start => \&do_start,
  restart => \&do_restart,
  quit => \&do_exit
);

#
# Главен цикъл за потребителски вход
while(1) {
  my $input_cv = AnyEvent->condvar;

  # Тук по друг начин четем входа от потребителя.  Създаваме си condvar и
  # watcher за IO събития.  На всяко събитие, изпълняваме команда.
  # Може да се направи по-качествено с AnyEvent::Handle.
  my $user_watch; $user_watch = AnyEvent->io(
    fh => \*STDIN,
    poll => 'r',
    cb => sub {
      chomp (my $op = <STDIN>);
      if (!exists $user_ops{$op}) {
        say "Не мога да извърша такава операция [$op]";
        $input_cv->send;
        return;
      }
      
      $user_ops{$op}->();
      $input_cv->send;
    }
  );

  $input_cv->recv;
}
