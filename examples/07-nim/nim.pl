#!/usr/bin/perl

use v5.12;
use strict;
use warnings;

use List::Util qw/first reduce/;
use Method::Signatures;

func game_init()
{
	return {
		board => {
			A => 3,
			B => 5,
			C => 7,
		},
		running => 1,
		turn => 1,
		players => {
			1 => {
				type => 'P',
				nick => 'Wade',
				name => 'Player One',
			},
			2 => {
				type => 'C',
				nick => 'WOPR',
				name => 'War Operation Plan Response',
			},
		},
	};
}

func ui_msg(Str $text)
{
	$text =~ s/[\r\n]*$//;
	$text =~ s/\r\n/\n/g;
	$text =~ s/\r/\n/g;

	say $text;
}

my %cmds = (
	BOARD => \&cmd_board,
	PLAY => \&cmd_play,
	PRAY => \&cmd_pray,
	QUIT => \&cmd_quit,
);

func cmd_pray(HashRef $game, Int $plidx, Str $cmd, Maybe[Str] $rest)
{
	return "Praying won't help you!";
}

func game_run_command(HashRef $game, Int $plidx, Str $text)
{
	my $hint = join ' ', sort keys %cmds;
	if ($text !~ /^\s*([A-Za-z0-9_.]+)(?:\s+(.+))?$/) {
		die "Invalid command, try one of $hint\n";
	}
	my ($cmd, $rest) = ( uc $1, $2);

	my @avail = grep { /^\Q$cmd\E/ } keys %cmds;
	if (!@avail) {
		die "Invalid command '$cmd', try one of $hint\n";
	} elsif (@avail > 1) {
		die "Ambiguous command '$cmd': ".join(' ', sort @avail)."\n";
	}
	my $h = $cmds{$avail[0]};
	
	if (ref($h) eq 'CODE') {
		return $h->($game, $plidx, $cmd, $rest);
	} 

	die "Internal error: the handler for '$cmd' is not ".
		    "a coderef, '".ref($h)."' instead\n";
}

func cmd_board(HashRef $game, Int $plidx, Str $cmd, Maybe[Str] $rest)
{
	if (defined($rest)) {
		die "Syntax: BOARD\n";
	}

	my $res = 'Players: '.
	    join(' ',
		map { $game->{players}{$_}{nick}.($_ == $game->{turn}? '*': '') }
		sort { $a <=> $b }
		keys %{$game->{players}}).
	    "\n";

	$res .= join '',
	    map { ($_, ' ', $game->{board}{$_}, "\n") }
	    sort keys %{$game->{board}};
	return $res;
}

func cmd_quit(HashRef $game, Int $plidx, Str $cmd, Maybe[Str] $rest)
{
	$game->{running} = 0;
	return 'Bye';
}

func cmd_play(HashRef $game, Int $plidx, Str $cmd, Maybe[Str] $rest)
{
	if (!defined($rest) || $rest !~ /^([A-Za-z])\s+([1-9][0-9]*)$/) {
		die "Syntax: PLAY row count\n";
	}
	my ($row, $count) = (uc $1, $2);

	my $v = $game->{board}{$row};
	if (!defined($v)) {
		die "Invalid row $row, try one of ".
		    join(' ', sort keys %{$game->{board}})."\n";
	} elsif ($v < $count) {
		die "Cannot take more than $v stone(s) from row $row\n";
	}

	my $player = $game->{players}{$plidx};
	ui_msg "PLAY $player->{nick} $row $count";
	$game->{board}{$row} -= $count;

	if ($v == $count &&
	    !defined first { $_ > 0 } values %{$game->{board}}) {
		ui_msg "WINNER $player->{nick}";
		$game->{running} = 0;
		return 'Congratulations, you won!';
	}

	$game->{turn} = 1 + $game->{turn} % scalar keys %{$game->{players}};
	return 'Good move... maybe';
}

func engine_play_random(HashRef $board, ArrayRef[Str] $rows)
{
	my $row = $rows->[int rand scalar @{$rows}];
	return ($row, 1 + int rand $board->{$row});
}

func engine_play(HashRef $game)
{
	my $board = $game->{board};
	my @rows = grep { $board->{$_} > 0 } keys %{$board};

	my $sum = reduce { $a ^ $b } @{$board}{@rows};
	if ($sum == 0) {
		# Argh...
		return engine_play_random($board, \@rows);
	}

	for my $row (@rows) {
		my $v = $board->{$row};

		for my $count (1..$v) {
			if (($sum ^ $v ^ ($v - $count)) == 0) {
				return ($row, $count);
			}
		}
	}
	die "Internal error: could not find a winning move\n";
}

MAIN:
{
	my $game = game_init();

	ui_msg 'OK '.game_run_command $game, 2, 'BOARD';

	while ($game->{running}) {
		my $turn = $game->{turn};
		my $player = $game->{players}{$turn};

		eval {
			if ($player->{type} eq 'P') {
				my $line = <> // 'quit';
				$line =~ s/[\r\n]*$//;

				ui_msg 'OK '.game_run_command $game, $turn, $line;
			} else {
				my ($row, $count) = engine_play $game;
				game_run_command $game, $turn, "PLAY $row $count";
			}
		};
		if ($@) {
			ui_msg "ERR $@";
			if ($player->{type} eq 'C') {
				die "Something went wrong on the computer's turn\n";
			}
		}
	}
}
