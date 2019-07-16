#!/usr/bin/perl

my $file = $ARGV[0]; # aln file from clustalw

my($cnt,$id,$seq,%SEQ,$len,$sp,%Max,$i,@arr,$base,$cnt,%Base,@SP,$max,$str,$sum);
open IN,'<',$file;
while(<IN>){
  chomp;
  $cnt++;
  ($id,$seq) = (split/\s+/,$_)[0,1];
  next if $cnt == 1 || $id eq '';
  $SEQ{$id}.=$seq;
}
close IN;

foreach (keys %SEQ){
  chomp;
  push @SP, $_;
  $len = length($SEQ{$_});
  $sp++;
  @arr = split//,$SEQ{$_};
  foreach $cnt (1..$len){
  $Base{$_}{$cnt} = $arr[$cnt-1];
  }
}

foreach $cnt (1..$len){
  chomp($cnt);
  %Max = ();
  foreach $str (@SP){
   chomp($str);
   $Max{$Base{$str}{$cnt}}++;
  }
  $max = 0;
  foreach $str (keys %Max){
  $max = $Max{$str} if $Max{$str} >= $max;
  } 
  $sum+=($max/$sp);
}

#print $sum."\t".$len."\n";
print sprintf("%.2f",$sum/$len);
