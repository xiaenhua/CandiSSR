#!/usr/bin/perl

my $file = $ARGV[0]; # fasta file
my $blast = $ARGV[1]; # blast files
my $len = $ARGV[2]; # flank length

#$len = 100;

my($id,$ref,%seq,$type,$st,$end,$flst,$flen,$flend,$ssrt,$num,$hitseq,$hitnum,@motif,$max,$str,$rep,$strand);

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

open IN,'<',$blast;
while(<IN>){
  chomp;
  ($id,$ref,$strand,$st,$end) = (split/\t/,$_)[0,2,4,7,8];
  next if $seq{$ref} eq '';

  ($ssrt,$num) = (split/\|/,$id)[1,2]; 
  
  if($st-1-$len < 0){
  $flst = 0;
  }
  else{
  $flst = $st-1-$len;
  }

  $flen = $end-$st+1+2*$len;

  if($end+$len > length($seq{$ref})){
  $flend = length($seq{$id}) -1;
  }
  else{
  $flend = $end - 1 + $len;
  }

  #print '>'.$id.'|'.$ssrt.'|'.$num.'|'.($flst+1).'-'.($flend+1)."\n".substr($seq{$ref},$flst,$flen)."\n" if substr($seq{$ref},$flst,$flen) ne '';
 
  next if substr($seq{$ref},$flst,$flen) eq '';

  $hitseq = substr($seq{$ref},$flst,$flen);

  $hitseq = &Comp($hitseq) if $strand eq '-1'; # REVERSE and COMP

  #print '>'.$id.'|'.$ssrt.'|'.$num.'|'.($flst+1).'-'.($flend+1)."\n".$hitseq."\n";

  chomp($ssrt);

  ## Set the repeat times ##
  $max = '';
  $rep = 2; # Update at 2017-6-2
  #if(length($ssrt) == 1){
  # $rep = 1;
  #}
  #elsif(length($ssrt) == 2){
  #$rep = 1;
  #}
  #else{
  #$rep = 1;
  #}

  ## Searching ##
  @motif = $hitseq =~ /((($ssrt){$rep,})+)/g;
  foreach $str (@motif){
  $max = $str if (length($str) > length($max));
  #print $str."\t".$max."\n";
  }

  ## Test Pos ##
  ($st) = (split/$max/,$hitseq)[0];
  #print $_."\n".length($st)."\t".(length($st)+length($max))."\n" if length($st) > 1;
  #next if length($st) < 90 || (length($st) > 110 && length($st) < 190) || (length($st) > 210);
  #next if length($st) < ($len-10) || (length($st) > ($len+10) && length($st) < (2*$len-10)) || (length($st) > (2*$len+10));

  ## Get Position ##
  if($strand eq '1'){
  ($st) = (split/$max/,$hitseq)[0];
  }
  else{
  ($st) = (split/$max/,$hitseq)[1];
  }

  $st = $flst+length($st);
  $end = ($st + length($max) -1);

  #print $id."\t".$ref.'|'.$ssrt.'|'.(length($max)/length($ssrt)).'|'.$strand.'|'.$st.'-'.$end.'|'.&Comp(substr($seq{$ref},$st,($end-$st+1)))."\n" if $max ne '' && $strand eq '-1';
  #print $id."\t".$ref.'|'.$ssrt.'|'.(length($max)/length($ssrt)).'|'.$strand.'|'.$st.'-'.$end.'|'.substr($seq{$ref},$st,($end-$st+1))."\n" if $max ne '' && $strand eq '1';
  #print $id."\t".$ref.'|'.$ssrt.'|'.(length($max)/length($ssrt)).'|'.$strand.'|'.$st.'-'.$end."\n" if $max ne '';

  my($newid,$newpos) = (split/\|/,$id)[0,-1];
  my($newst,$newend) = (split/\-/,$newpos)[0,1];

  $strand = '+' if $strand == 1;
  $strand = '-' if $strand == -1;

  print $ssrt.'/'.$num.'|'.$newid.':'.($newst).'-'.($newend)."\t".(length($max)/length($ssrt)).'|'.$ref.':'.($st+1).'-'.($end+1)."|$strand"."\n" if $max ne '';
  #print substr($seq{$ref},($st-$len),($end-$st+1+2*$len))."\n";
}
close IN;

sub Comp{
  my $sequence = shift @_;
  $sequence = reverse($sequence);
  $sequence =~ tr/ATCGN/TAGCN/;
  return $sequence;
}
