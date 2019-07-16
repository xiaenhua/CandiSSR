#!/usr/bin/perl

my $file = $ARGV[0]; # fasta file
my $ssr = $ARGV[1]; # ssr files
my $len = $ARGV[2]; # flank length

my($id,%seq,$type,$st,$end,$flst,$flen,$flend,$ssrt,$num);
open IN,'<',$file;
while(<IN>){
  chomp;
  if(/^>/){
  s/^>//;
  $id = $_;
  $seq{$id} = '';
  }
  else{
  $seq{$id}.=$_;
  }
}
close IN;

open IN,'<',$ssr;
while(<IN>){
  chomp;
  ($id,$type,$st,$end) = (split/\s+/,$_)[0,3,-2,-1];
  next if $seq{$id} eq '' || length($type) > 10;

  ($ssrt,$num) = $type =~ /^\((\w+)\)(\d+)$/;
  next if $ssrt eq '' || $num eq '' || length($ssrt) < 2;
  #next if $ssrt eq '' || $num eq '';

  if($st-1-$len < 0){
  $flst = 0;
  }
  else{
  $flst = $st-1-$len;
  }

  $flen = $end-$st+1+2*$len;

  if($end+$len > length($seq{$id})){
  $flend = length($seq{$id}) -1;
  }
  else{
  $flend = $end - 1 + $len;
  }

  print '>'.$id.'|'.$ssrt.'|'.$num.'|'.($flst+1).'-'.($flend+1)."\n".substr($seq{$id},$flst,$flen)."\n" if substr($seq{$id},$flst,$flen) ne '';
}
close IN;
