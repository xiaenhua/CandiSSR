#!/usr/bin/perl

my $file = $ARGV[0];
my $sp = $ARGV[1];

open OUT,'>',$sp.'_SeqID_Conversion';
my($id,$cnt);
open IN,'<',$file;
while(<IN>){
  chomp;
  if(/^>/){
  $cnt++;
  s/^>//;
  ($id) = (split/\s+/,$_)[0];
  print OUT $sp.'_'.$cnt."\t".$id."\n";
  print '>'.$sp.'_'.$cnt."\n";
  }
  else{
  tr/atcgn/ATCGN/;
  print $_."\n";
  }
}
close IN;
close OUT;
