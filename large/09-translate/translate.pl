#!/usr/bin/perl

use strict;
use warnings;
use v5.014;

use Lingua::Translate::Bing;
use Spreadsheet::ParseExcel;
use DBI;
use Tie::Hash::DBD;
use open OUT => ':utf8';

## prepare translate

my $tr = Lingua::Translate::Bing->new(
	client_id => "09207e20-49bc-4f0d-908e-2e25de7e43a1", 
	client_secret => "6qJx1foEFywaco+vI+Ez4+MqkhUcfLlHp1SJ82V2YNo=");

## prepare load

my $parser   = Spreadsheet::ParseExcel->new();
my $wbold = $parser->parse('src.xls');

die "could not open spreadsheet: $!" unless $wbold;

my @sheets = $wbold->worksheets();
my $ws = $sheets[0];

my ( $row_min, $row_max ) = $ws->row_range();

## prepare out

say "load source... ";

use Spreadsheet::WriteExcel;

my $wbnew = Spreadsheet::WriteExcel->new('processed.xls');
my $wsnew = $wbnew->add_worksheet();

## do all

say "tie db... ";

tie my %dict, 
	"Tie::Hash::DBD", 
	"dbi:SQLite:dbname=dict.db",
	{
		tbl => "t_dict",
		key => "h_key",
		fld => "h_value",
		str => "Storable",
		trh => 0,
	};

say "total rows... [$row_max] ";

#for my $row ( 1 .. $row_max ) {
for my $row ( 1 .. $row_max) {
	say sprintf "processing row [%d] of [%d], %d \% ", 
		$row, $row_max, (int $row/$row_max * 100)

		if ($row % 10) == 0;

	my $type = $ws->get_cell($row, 0);  
	my $context = $ws->get_cell($row, 1);  
 	my $encell = $ws->get_cell($row, 2); 
	my $bgcell = $ws->get_cell($row, 3); 

 	if ( ( not defined $bgcell or not length $bgcell->value ) and defined $encell )  {
 		my $en = $encell->value;
 		my $bgt;
 		if ( exists $dict{$en} ) {
 			$bgt = $dict{$en};
 			say sprintf "record [%s] already present. using cache ", $en;
 		} else {
 			$bgt = $dict{$en} = $tr->translate( $en, 'bg');
 		}

 		$wsnew->write($row, 3, $bgt);
	}

	$wsnew->write($row, 0, $type->value) if defined $type;
	$wsnew->write($row, 1, $context->value) if defined $context;
	$wsnew->write($row, 2, $encell->value) if defined $encell;
}



