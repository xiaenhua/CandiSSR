#!/usr/bin/perl -w

use strict;

my $FasFile = $ARGV[0]; # Input fasta fle

if(!$FasFile){
  print "\nperl $0 Fasta_File > New_Fasta_File\n\n";
  exit;
  }

open IN,'<',$FasFile;
while(<IN>){
  chomp;
  s/\r//g;
  print $_."\n";
  }
  close IN;
