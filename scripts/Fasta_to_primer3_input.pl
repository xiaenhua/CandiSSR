#!/usr/bin/perl -w

## Copyright (c) KIB 2015
## Author:         Qiu-Yang Yao <yaoqiuyang@mail.kib.ac.cn> & En-Hua Xia <xiaenhua@mail.kib.ac.cn>
## Program Date:   2015.4.20
## Modifier:       Qiu-Yang Yao <yaoqiuyang@mail.kib.ac.cn> & En-Hua Xia <xiaenhua@mail.kib.ac.cn>
## Last Modified:  2015.4.20
## Version:        1.0
##

my $fas = $ARGV[0]; # fasta file
my $primer3_config = $ARGV[1]; # directory of primer3 config

my($id,%seq,@arr,$type,$num,$str,$pos,$ssr);
open IN,'<',$fas || die ("\nError: Couldn't open fasta file !\n\n");

while(<IN>){
  chomp;
  if(/^>/){
  s/^>//;
  $id = $_;
  push @arr, $id;
  $seq{$id} = '';
  }
  else{
  $seq{$id}.=$_;
  }
}
close IN;

open OUT, '>',$fas.'.primer3input';
foreach $id (@arr){
  chomp($id);
  ($str,$type,$num) = (split/\|/,$id)[0,1,2];
  $ssr = ($type)x($num);
  $pos = length((split/$ssr/,$seq{$id})[0]) + 1;
  print OUT "SEQUENCE_ID=$str\|$type\nSEQUENCE_TEMPLATE=$seq{$id}\n"; # PRIMER_SEQUENCE_ID~SEQUENCE_ID    SEQUENCE~SEQUENCE_TEMPLATE
  print OUT "SEQUENCE_TARGET=".$pos.",".length($ssr)."\n"; # TARGET~SEQUENCE_TARGET;  There is a simple sequence repeat in this sequence. The repeat starts at base $pos, with a length of length($ssr).
  print OUT "SEQUENCE_EXCLUDED_REGION=".$pos.",".length($ssr)."\n"; # Primers and oligos may not overlap any region specified in this tag.
  print OUT "PRIMER_PRODUCT_SIZE_RANGE=100-200\n"; # PRIMER_PRODUCT_SIZE_RANGE(still work)
  print OUT "PRIMER_TASK=generic\n";
  print OUT "PRIMER_NUM_RETURN=3\n";#The maximum number of primer (pairs) to return.(int; default 5)
  print OUT "PRIMER_MIN_SIZE=18\n";
  print OUT "PRIMER_MAX_SIZE=24\n";
  print OUT "PRIMER_OPT_SIZE=20\n";
  print OUT "PRIMER_MAX_TM=63\n";
  print OUT "PRIMER_MIN_TM=52\n"; # Primers with melting temperatures in the range of 52-58 oC generally produce the best results. Primers with melting temperatures above 65oC have a tendency for secondary annealing.
  print OUT "PRIMER_PAIR_MAX_DIFF_TM=5\n"; # Maximum acceptable (unsigned) difference between the melting temperatures of the left and right primers.
  print OUT "PRIMER_MAX_GC=60\n";
  print OUT "PRIMER_MIN_GC=40\n";
  print OUT "PRIMER_MAX_SELF_ANY=5\n"; # PRIMER_MAX_SELF_ANY describes the tendency of a primer to bind to itself (interfering with target sequence binding). It will score ANY binding occurring within the entire primer sequence.The scoring system gives 1.00 for complementary bases, -0.25 for a match of any base (or N) with an N, -1.00 for a mismatch, and -2.00 for a gap. Only single-base-pair gaps are allowed.
  print OUT "PRIMER_MAX_SELF_END=3\n"; # PRIMER_MAX_SELF_END tries to bind the 3'-END to a identical primer and scores the best binding it can find.
  print OUT "PRIMER_MAX_POLY_X=4\n"; # The maximum allowable length of a mononucleotide repeat, for example AAAAAA.default 5
  print OUT "PRIMER_MAX_END_GC=3\n"; # The maximum number of Gs or Cs allowed in the last five 3' bases of a left or right primer.
  print OUT "PRIMER_MAX_NS_ACCEPTED=1\n"; # Maximum number of unknown bases (N) allowable in any primer.print OUT "PRIMER_MAX_END_STABILITY=5\n";#The maximum stability for the last five 3' bases of a left or right primer. Bigger numbers mean more stable 3' ends. The value is the maximum delta G (kcal/mol) for duplex disruption for the five 3' bases as calculated using the nearest-neighbor parameter values specified by the option of PRIMER_TM_FORMULA. For example if the table of thermodynamic parameters suggested by SantaLucia 1998, DOI:10.1073/pnas.95.4.1460 is used the deltaG values for the most stable and for the most labile 5mer duplex are 6.86 kcal/mol (GCGCG) and 0.86 kcal/mol (TATAT) respectively
  print OUT "PRIMER_THERMODYNAMIC_PARAMETERS_PATH=$primer3_config\n=\n";
}
close IN;
close OUT;
