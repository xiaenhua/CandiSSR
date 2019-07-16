#!/usr/bin/perl -w

## Copyright (c) KIB 2015
## Author:         Qiu-Yang Yao <yaoqiuyang@mail.kib.ac.cn> & En-Hua Xia <xiaenhua@mail.kib.ac.cn>
## Program Date:   2015.4.20
## Modifier:       Qiu-Yang Yao <yaoqiuyang@mail.kib.ac.cn> & En-Hua Xia <xiaenhua@mail.kib.ac.cn>
## Last Modified:  2015.4.20
## Version:        1.0
##

undef $/;
$/ = "=\n";

my $outfile = $ARGV[0]; # primer3 output file
my $filename = $outfile;
$filename =~ s/\.primer3output$//;

my($id,$str,$leftnum,$rightnum);
open IN,'<',$outfile;
open OUT,'>',$filename.'.primers';

print OUT "CPSSRID\t";
print OUT "Forward primer1 (5'->3')\tTm (centigrade)\tSize (bp)\tReverse primer1 (5'->3')\tTm (centigrade)\tSize (bp)\tProduct1 size (bp)\tStart\tEnd\t";
print OUT "Forward primer2 (5'->3')\tTm (centigrade)\tSize (bp)\tReverse primer2 (5'->3')\tTm (centigrade)\tSize (bp)\tProduct2 size (bp)\tStart\tEnd\t";
print OUT "Forward primer3 (5'->3')\tTm (centigrade)\tSize (bp)\tReverse primer3 (5'->3')\tTm (centigrade)\tSize (bp)\tProduct3 size (bp)\tStart\tEnd\n";

while(<IN>){
  chomp;
  ($id) = (/SEQUENCE_ID=(.*)/); # Retrieve sequence ID # PRIMER_SEQUENCE_ID~SEQUENCE_ID

  ($leftnum) = $_ =~ /PRIMER_LEFT_NUM_RETURNED=(\d+)/;
  ($rightnum) = $_ =~ /PRIMER_RIGHT_NUM_RETURNED=(\d+)/;
  
  if($leftnum == 0 || $rightnum == 0){
  print OUT $id."\t".'Primers not available'."\n";
  next;
  }

  /PRIMER_LEFT_0_SEQUENCE=(.*)/;
  $str = "$1\t";
  /PRIMER_LEFT_0_TM=(.*)/;
  $str .= "$1\t";
  /PRIMER_LEFT_0=\d+,(\d+)/;
  $str .= "$1\t";
  
  /PRIMER_RIGHT_0_SEQUENCE=(.*)/;
  $str .= "$1\t";
  /PRIMER_RIGHT_0_TM=(.*)/;
  $str .= "$1\t";
  /PRIMER_RIGHT_0=\d+,(\d+)/;
  $str .= "$1\t";
  
  /PRIMER_PAIR_0_PRODUCT_SIZE=(.*)/;
  $str .= "$1\t";
  /PRIMER_LEFT_0=(\d+),\d+/;
  $str .= "$1\t";
  /PRIMER_RIGHT_0=(\d+),\d+/;
  $str .= "$1\t";
  
  /PRIMER_LEFT_1_SEQUENCE=(.*)/;
  $str .= "$1\t";
  /PRIMER_LEFT_1_TM=(.*)/;
  $str .= "$1\t";
  /PRIMER_LEFT_1=\d+,(\d+)/;
  $str .= "$1\t";
    
  /PRIMER_RIGHT_1_SEQUENCE=(.*)/;
  $str .= "$1\t";
  /PRIMER_RIGHT_1_TM=(.*)/;
  $str .= "$1\t";
  /PRIMER_RIGHT_1=\d+,(\d+)/;
  $str .= "$1\t";
  
  /PRIMER_PAIR_1_PRODUCT_SIZE=(.*)/;
  $str .= "$1\t";
  /PRIMER_LEFT_1=(\d+),\d+/;
  $str .= "$1\t";
  /PRIMER_RIGHT_1=(\d+),\d+/;
  $str .= "$1\t";
  
  /PRIMER_LEFT_2_SEQUENCE=(.*)/;
  $str .= "$1\t";
  /PRIMER_LEFT_2_TM=(.*)/;
  $str .= "$1\t";
  /PRIMER_LEFT_2=\d+,(\d+)/;
  $str .= "$1\t";
    
  /PRIMER_RIGHT_2_SEQUENCE=(.*)/;
  $str .= "$1\t";
  /PRIMER_RIGHT_2_TM=(.*)/;
  $str .= "$1\t";
  /PRIMER_RIGHT_2=\d+,(\d+)/;
  $str .= "$1\t";
  
  /PRIMER_PAIR_2_PRODUCT_SIZE=(.*)/;
  $str .= "$1\t"; # PRIMER_PAIR_0_PRODUCT_SIZE~PRIMER_PRODUCT_SIZE_2
  /PRIMER_LEFT_2=(\d+),\d+/;
  $str .= "$1\t";
  /PRIMER_RIGHT_2=(\d+),\d+/;
  $str .= "$1";
  
  print OUT "$id\t$str\n";

}
close IN;
