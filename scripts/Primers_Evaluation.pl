#!/usr/bin/perl

# For three primers

my $file1 = $ARGV[0]; # CandiSSR_Output_SeqForPrimerEvaluation.fas
my $file2 = $ARGV[1]; # CandiSSR_Output_SeqForPrimerDesign.fas.primers
my $dir = $ARGV[2];    # blastall directory
my $scripts = $ARGV[3]; # scripts home

$scripts = $scripts.'/scripts';

my($id,%seq,$str,@arr,$type,$blx,$qlen,$rlen,$qst,$qend,$iden,$cnt,$sum_iden,$sum_cov);
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
  if(/Primers not available/){
   print $_."\n";
   next;
  }
  
  @arr = split/\t/,$_;
 
  if($arr[0] eq 'CPSSRID'){
   print $arr[0]."\t".$arr[1]."\t".$arr[2]."\t".$arr[3]."\tAverage identity (%)\tAverage coverage (%)"."\t".$arr[4]."\t".$arr[5]."\t".$arr[6]."\tAverage identity (%)\tAverage coverage (%)"."\t".$arr[7]."\t".$arr[8]."\t".$arr[9]."\t";
   print $arr[10]."\t".$arr[11]."\t".$arr[12]."\tAverage identity (%)\tAverage coverage (%)"."\t".$arr[13]."\t".$arr[14]."\t".$arr[15]."\tAverage identity (%)\tAverage coverage (%)"."\t".$arr[16]."\t".$arr[17]."\t".$arr[18]."\t";
   print $arr[19]."\t".$arr[20]."\t".$arr[21]."\tAverage identity (%)\tAverage coverage (%)"."\t".$arr[22]."\t".$arr[23]."\t".$arr[24]."\tAverage identity (%)\tAverage coverage (%)"."\t".$arr[25]."\t".$arr[26]."\t".$arr[27]."\n";
   next;
   }
  
   ## primer1
   # Left
   print $arr[0]."\t".$arr[1]."\t".$arr[2]."\t".$arr[3]."\t";
   open QUERY,'>','QUERY.fas';
   print QUERY '>'.$arr[0]."\n".$arr[1]."\n";
   close QUERY;

   $cnt = 0;
   $sum_iden = 0;
   $sum_cov = 0;
   foreach $id (keys %seq){
   chomp($id);
   ($str,$type) =  (split/\|/,$id)[0,1];
   $str = $str.'|'.$type;
   next if $str ne $arr[0];
   open TARGET,'>','TARGET.fas';
   print TARGET '>'.$id."\n".$seq{$id}."\n";
   close TARGET;
   #### blastall ###
   system("$dir/formatdb -i TARGET.fas -p F");
   system("$dir/blastall -p blastn -i QUERY.fas -d TARGET.fas -F F -a 10 -b 5 -v 5 -o TMP.out");
   system("perl $scripts/Blast_Parsing.pl TMP.out 1 TMP.ps");
   #system("");
   #### Get Similarity and Coverage ####
   open BLX,'<','TMP.ps';
   while($blx = <BLX>){
    chomp($blx);
    next if $blx =~ /^query_name/;
    next if $blx =~ /No hits found/;
    ($qlen,$rlen,$qst,$qend,$iden) = (split/\t/,$blx)[1,3,10,11,-1];
    next if $qlen !~ /\d+/ || $rlen !~ /\d+/;
    $cnt++;
    $iden =~ s/\%$//;
    $sum_iden+=$iden;
    $sum_cov+=(abs($qend-$qst+1)/$qlen);
    }
   }
    print sprintf("%.2f",$sum_iden/$cnt)."\t".sprintf("%.2f",100*$sum_cov/$cnt)."\t" if $cnt != 0;
    print "N/A\tN/A\t" if $cnt == 0;

   # Right
   print $arr[4]."\t".$arr[5]."\t".$arr[6]."\t";
   open QUERY,'>','QUERY.fas';
   print QUERY '>'.$arr[0]."\n".$arr[4]."\n";
   close QUERY;

   $cnt = 0;
   $sum_iden = 0;
   $sum_cov = 0;
   foreach $id (keys %seq){
   chomp($id);
   ($str,$type) =  (split/\|/,$id)[0,1];
   $str = $str.'|'.$type;
   next if $str ne $arr[0];
   open TARGET,'>','TARGET.fas';
   print TARGET '>'.$id."\n".$seq{$id}."\n";
   close TARGET;
   #### blastall ###
   system("$dir/formatdb -i TARGET.fas -p F");
   system("$dir/blastall -p blastn -i QUERY.fas -d TARGET.fas -F F -a 10 -b 5 -v 5 -o TMP.out");
   system("perl $scripts/Blast_Parsing.pl TMP.out 1 TMP.ps");
   #### Get Similarity and Coverage ####
   open BLX,'<','TMP.ps';
   while($blx = <BLX>){
    chomp($blx);
    next if $blx =~ /^query_name/;
    next if $blx =~ /No hits found/;
    ($qlen,$rlen,$qst,$qend,$iden) = (split/\t/,$blx)[1,3,10,11,-1];
    next if $qlen !~ /\d+/ || $rlen !~ /\d+/;
    $cnt++;
    $iden =~ s/\%$//;
    $sum_iden+=$iden;
    $sum_cov+=(abs($qend-$qst+1)/$qlen);
    }
   }
    print sprintf("%.2f",$sum_iden/$cnt)."\t".sprintf("%.2f",100*$sum_cov/$cnt)."\t" if $cnt != 0;
    print "N/A\tN/A\t" if $cnt == 0;

    # Pairs
    print $arr[7]."\t".$arr[8]."\t".$arr[9]."\t";

   # primer2
   # Left
   print $arr[10]."\t".$arr[11]."\t".$arr[12]."\t";
   open QUERY,'>','QUERY.fas';
   print QUERY '>'.$arr[0]."\n".$arr[10]."\n";
   close QUERY;

   $cnt = 0;
   $sum_iden = 0;
   $sum_cov = 0;
   foreach $id (keys %seq){
   chomp($id);
   ($str,$type) =  (split/\|/,$id)[0,1];
   $str = $str.'|'.$type;
   next if $str ne $arr[0];
   open TARGET,'>','TARGET.fas';
   print TARGET '>'.$id."\n".$seq{$id}."\n";
   close TARGET;
   ### blastall ###
   system("$dir/formatdb -i TARGET.fas -p F");
   system("$dir/blastall -p blastn -i QUERY.fas -d TARGET.fas -F F -a 10 -b 5 -v 5 -o TMP.out");
   system("perl $scripts/Blast_Parsing.pl TMP.out 1 TMP.ps");
   #### Get Similarity and Coverage ####
   open BLX,'<','TMP.ps';
   while($blx = <BLX>){
    chomp($blx);
    next if $blx =~ /^query_name/;
    next if $blx =~ /No hits found/;
    ($qlen,$rlen,$qst,$qend,$iden) = (split/\t/,$blx)[1,3,10,11,-1];
    next if $qlen !~ /\d+/ || $rlen !~ /\d+/;
    $cnt++;
    $iden =~ s/\%$//;
    $sum_iden+=$iden;
    $sum_cov+=(abs($qend-$qst+1)/$qlen);
    }
   }
    print sprintf("%.2f",$sum_iden/$cnt)."\t".sprintf("%.2f",100*$sum_cov/$cnt)."\t" if $cnt != 0;
    print "N/A\tN/A\t" if $cnt == 0;

   # Right
   print $arr[13]."\t".$arr[14]."\t".$arr[15]."\t";
   open QUERY,'>','QUERY.fas';
   print QUERY '>'.$arr[0]."\n".$arr[13]."\n";
   close QUERY;

   $cnt = 0;
   $sum_iden = 0;
   $sum_cov = 0;
   foreach $id (keys %seq){
   chomp($id);
   ($str,$type) =  (split/\|/,$id)[0,1];
   $str = $str.'|'.$type;
   next if $str ne $arr[0];
   open TARGET,'>','TARGET.fas';
   print TARGET '>'.$id."\n".$seq{$id}."\n";
   close TARGET;
   ### blastall ###
   system("$dir/formatdb -i TARGET.fas -p F");
   system("$dir/blastall -p blastn -i QUERY.fas -d TARGET.fas -F F -a 10 -b 5 -v 5 -o TMP.out");
   system("perl $scripts/Blast_Parsing.pl TMP.out 1 TMP.ps");
   #### Get Similarity and Coverage ####
   open BLX,'<','TMP.ps';
   while($blx = <BLX>){
    chomp($blx);
    next if $blx =~ /^query_name/;
    next if $blx =~ /No hits found/;
    ($qlen,$rlen,$qst,$qend,$iden) = (split/\t/,$blx)[1,3,10,11,-1];
    next if $qlen !~ /\d+/ || $rlen !~ /\d+/;
    $cnt++;
    $iden =~ s/\%$//;
    $sum_iden+=$iden;
    $sum_cov+=(abs($qend-$qst+1)/$qlen);
    }
   }
    print sprintf("%.2f",$sum_iden/$cnt)."\t".sprintf("%.2f",100*$sum_cov/$cnt)."\t" if $cnt != 0;
    print "N/A\tN/A\t" if $cnt == 0;

    # Pairs
    print $arr[16]."\t".$arr[17]."\t".$arr[18]."\t";

   ### primer3
   # Left
   print $arr[19]."\t".$arr[20]."\t".$arr[21]."\t";
   open QUERY,'>','QUERY.fas';
   print QUERY '>'.$arr[0]."\n".$arr[19]."\n";
   close QUERY;

   $cnt = 0;
   $sum_iden = 0;
   $sum_cov = 0;
   foreach $id (keys %seq){
   chomp($id);
   ($str,$type) =  (split/\|/,$id)[0,1];
   $str = $str.'|'.$type;
   next if $str ne $arr[0];
   open TARGET,'>','TARGET.fas';
   print TARGET '>'.$id."\n".$seq{$id}."\n";
   close TARGET;
   ### blastall ###
   system("$dir/formatdb -i TARGET.fas -p F");
   system("$dir/blastall -p blastn -i QUERY.fas -d TARGET.fas -F F -a 10 -b 5 -v 5 -o TMP.out");
   system("perl $scripts/Blast_Parsing.pl TMP.out 1 TMP.ps");
   ### Get Similarity and Coverage ####
   open BLX,'<','TMP.ps';
   while($blx = <BLX>){
    chomp($blx);
    next if $blx =~ /^query_name/;
    next if $blx =~ /No hits found/;
    ($qlen,$rlen,$qst,$qend,$iden) = (split/\t/,$blx)[1,3,10,11,-1];
    next if $qlen !~ /\d+/ || $rlen !~ /\d+/;
    $cnt++;
    $iden =~ s/\%$//;
    $sum_iden+=$iden;
    $sum_cov+=(abs($qend-$qst+1)/$qlen);
    }
   }
    print sprintf("%.2f",$sum_iden/$cnt)."\t".sprintf("%.2f",100*$sum_cov/$cnt)."\t" if $cnt != 0;
    print "N/A\tN/A\t" if $cnt == 0;

   # Right
   print $arr[22]."\t".$arr[23]."\t".$arr[24]."\t";
   open QUERY,'>','QUERY.fas';
   print QUERY '>'.$arr[0]."\n".$arr[22]."\n";
   close QUERY;

   $cnt = 0;
   $sum_iden = 0;
   $sum_cov = 0;
   foreach $id (keys %seq){
   chomp($id);
   ($str,$type) =  (split/\|/,$id)[0,1];
   $str = $str.'|'.$type;
   next if $str ne $arr[0];
   open TARGET,'>','TARGET.fas';
   print TARGET '>'.$id."\n".$seq{$id}."\n";
   close TARGET;
   ### blastall ###
   system("$dir/formatdb -i TARGET.fas -p F");
   system("$dir/blastall -p blastn -i QUERY.fas -d TARGET.fas -F F -a 10 -b 5 -v 5 -o TMP.out");
   system("perl $scripts/Blast_Parsing.pl TMP.out 1 TMP.ps");
   ### Get Similarity and Coverage ####
   open BLX,'<','TMP.ps';
   while($blx = <BLX>){
    chomp($blx);
    next if $blx =~ /^query_name/;
    next if $blx =~ /No hits found/;
    ($qlen,$rlen,$qst,$qend,$iden) = (split/\t/,$blx)[1,3,10,11,-1];
    next if $qlen !~ /\d+/ || $rlen !~ /\d+/;
    $cnt++;
    $iden =~ s/\%$//;
    $sum_iden+=$iden;
    $sum_cov+=(abs($qend-$qst+1)/$qlen);
    }
   }
    print sprintf("%.2f",$sum_iden/$cnt)."\t".sprintf("%.2f",100*$sum_cov/$cnt)."\t" if $cnt != 0;
    print "N/A\tN/A\t" if $cnt == 0;

    # Pairs
    print $arr[25]."\t".$arr[26]."\t".$arr[27]."\n";

}

close IN;

