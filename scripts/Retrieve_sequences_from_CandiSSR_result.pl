#!/usr/bin/perl

my $file1 = $ARGV[0]; # Renamed fasta, such as: COL.fasta
my $file2 = $ARGV[1]; # ID_Conv, such as: COL_SeqID_Conversion
my $file3 = $ARGV[2]; # output, such as: CandiSSR_Output.results

if(!$file1 || !$file2 || !$file3){
 print "\nDescription:\n\n\tRetrieve the SSR containing sequences from CandiSSR output\nUsage: \n\n\tperl $0 Species_Renamed.fasta Species_SeqID_Conversion Prefix.result\n\n";
 exit(0);
}

my($id,%seq,%ID,$str,@arr);
open IN,'<',$file1;
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

open IN,'<',$file2;
while(<IN>){
  chomp;
  ($id,$str) = split/\t/,$_;
  $ID{$id} = $str;  
}
close IN;

open IN,'<',$file3;
while(<IN>){
  chomp;
  @arr = split/\t/,$_;
  foreach $id (@arr){
  ($id) = (split/\|/,$id)[1];
  ($id) = (split/\:/,$id)[0];
  next if $seq{$id} eq '';
  print '>'.$ID{$id}."\n".$seq{$id}."\n";
  }
}
close IN;
