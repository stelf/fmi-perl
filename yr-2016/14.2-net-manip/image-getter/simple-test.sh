#!/bin/bash

perlbrew use perl-v5.20.2

one_link=`perlbrew exec client.pl xml 'http://fmi.uni-sofia.bg'`
if [[ $one_link 
