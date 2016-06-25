#!/usr/bin/env perl

use strict;
use warnings;
use v5.014;


use LWP::UserAgent; # използваме го за HTTP комуникация
use HTML::LinkExtor; # с това ходим по линковете в дадена HTML страница
use URI::URL; # манипулация на URL-и
use File::Path qw/make_path/; # платформено-независима работа с файловата с-ма


#
# Тази функция има за цел да зареди страница, подадена ѝ като URL и да вземе
# всички линкове към изображения в нея.
sub get_image_links {
  my $url = shift;

  my $ua = LWP::UserAgent->new;
  # прочитаме страницата от URL-a
  my $res = $ua->request(HTTP::Request->new(GET => $url));

  # 
  # Тази функция ще създаде затваряне (closure), което ще се извиква от
  # HTML::LinkExtor # за всеки линк в дадена HTML страница.
  # Нужно е да създаваме функция, защото трябва в процеса на обхождане на
  # страницата да трупаме намерените изображения някъде.  Понеже не е добра
  # практика да се използват глобални променливи, подаваме референция към
  # списъка, в който ще трупаме намерените изображения.  Тази референция се
  # вижда от затварянето и то може спокойно да си трупа в нея.
  sub image_parse {
    my $imgs_ref = shift; 

    # 
    # Функцията, която реално намира изображенията в дадена страница.
    return sub {
      my ($tag, %attr) = @_;
      return if $tag ne 'img'; # ако HTML тагът е img, значи сме на прав път

      # добавяме стойностите на всички атрибути на тага
      # на вашето забавление оставям да добавяте само src атрибутите :)
      push @$imgs_ref, values %attr;
    }
  }

  my @imgs;
  my $p = HTML::LinkExtor->new(image_parse(\@imgs));
  if ($res->is_success) {
    # взимаме изображенията от страницата, ако успешно сме я прочели
    $p->parse($res->content);
  }

  # конвертираме линковете към URL обекти с абсолютни пътища за лесна
  # манипулация
  @imgs = map { url($_, $res->base)->abs; } @imgs;
}

#
# Тази функция тегли файлове от списък с линкове и ги записва в дадена
# директория.
sub download_files_by_links {
  my $download_path = shift;
  my @links = @_;

  my $ua = LWP::UserAgent->new();

  # ако нямаме директория, създаваме я
  # тук ще е хубаво да се провери за грешки при създаването на директория :)
  if (!-d $download_path) {
    make_path $download_path;
  }

  my $i = 0;
  for my $link (@links) {
    # следващите два реда взимат името на файла от URL сочещ към него
    my @path_parts = $link->path_segments;
    my $file_name = $path_parts[$#path_parts];
    # може да имаме URL с празно име на файл. Тогава няма какво да записваме
    next if !$file_name;

    # с mirror записваме файл, сочен от даден URL на локация в нашата
    # файлова система
    $ua->mirror($link, "$download_path/$file_name");
  }
}

# композираме двете функции за да си свършим работата :)
download_files_by_links("./downloads", get_image_links("https://xkcd.com"));
