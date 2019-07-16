#!/usr/bin/perl

my $file1 = $ARGV[0]; # *.temp
my $file2 = $ARGV[1]; # Ref_SSR_Flanking_100bp.fasta
my $len = $ARGV[2]; # Flanking length

my($id,$st,$end,$pos,$num,%seq,$type,$str,$std,$cnt,$mr);
open IN,'<',$file2;
while(<IN>){
  chomp;
  if(/^>/){
  s/^>//;
  ($id,$num,$pos) = (split/\|/,$_)[0,2,-1];
  $id = $num.'|'.$id.':'.$pos;
  $seq{$id} = '';
  }
  else{
  $seq{$id}.=$_;
  }
}
close IN;

open IN,'<',$file1;
while(<IN>){
  chomp;
  $cnt++;
  if($cnt == 1){
  print $_."\tUpstream_".$len."bp\tDownstream_".$len."bp\n";
  next;
  }
  ($type,$str,$std,$mr) = (split/\t/,$_)[0,1,-2,-1];
  next if $std == 0 || length($type) < 2 || $mr > 0.5;
  #next if $std == 0 || $mr > 0.5;
  ($num,$id) = (split/\|/,$str)[0,1];
  $id = $str;
  $str = ($type)x($num);
  #print "$id\n";
  ($st,$end) = (split/$str/,$seq{$id})[0,1];
  next if length($st) != $len || length($end) != $len;
  print $_."\t".$st."\t".$end."\n";
}
close IN;
