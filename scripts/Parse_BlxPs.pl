#!/usr/bin/perl

my $blast = $ARGV[0];  # blast.out
my $cov_cutoff = $ARGV[1];
my $iden_cutoff = $ARGV[2];

my($query,$len,$ref,$des,$eval,$score,$st,$qend,$iden);

open IN,'<',$blast;
while(<IN>){
  chomp;
  next if /^\s+/;
  next if /^query_name/;
  my($query,$len,$ref,$des,$eval,$score,$qstrand,$rstrand,$qst,$qend,$rst,$rend,$iden)=(split/\t/,$_)[0,1,2,4,5,6,7,8,10,11,12,13,-1];  #print $eval."\t".$score."\n";
  $ref=~s/\s+//g;
  $iden =~ s/\%//;
  next if $ref eq 'Nohitsfound' || $len !~ /\d+/ || $ref eq '' || 100*(abs($qend - $qst + 1)/$len) < $cov_cutoff || $iden < $iden_cutoff;
  print $query."\t".$len."\t".$ref."\t".$qstrand."\t".$rstrand."\t".$qst."\t".$qend."\t".$rst."\t".$rend."\t".$eval."\t".sprintf("%.2f",100*(abs($qend - $qst + 1)/$len))."\t".$iden."\n";
}
close IN;

