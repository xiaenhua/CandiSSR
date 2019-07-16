#!/usr/bin/perl -w

use strict;

## Enhua Xia @ AHAU
## 2018/11/27

my $GffFile = $ARGV[0]; # GFF3
my $PolySSRFile = $ARGV[1]; # *_PolySSRs.txt

my($scaf, $type, $st, $end, $str, $idx, %Gene, %Location, $middle, @arr);
my($cpid, %Count, $ref);

if(!$GffFile || !$PolySSRFile){
  print "\nperl $0 annotation.gff3 PolySR.txt\n\n";
  exit;
  }

open IN,'<',$GffFile;
while(<IN>){
  chomp;
  next if /^#/;
  ($scaf, $type, $st, $end) = (split/\t/,$_)[0,2,3,4];
  $str = $scaf.'|'.$st.'|'.$end;
  $Gene{$str} = 1 if $type eq 'gene';
  if($type eq 'exon'){
    foreach $idx ($st..$end){
        $Location{$scaf}{$idx} = 'exon';
        }
     }

  if($type =~ /five/){
    foreach $idx ($st..$end){
        $Location{$scaf}{$idx} = 'five_prime_UTR';
        }
     }

  if($type =~ /three/){
    foreach $idx ($st..$end){
        $Location{$scaf}{$idx} = 'three_prime_UTR';
        }
     }

  }
  close IN;
my $cnt = 0;
foreach (keys %Gene){
  chomp;
  $cnt++;
  ($scaf, $st, $end) = split/\|/,$_;
  foreach $idx ($st..$end){
     $Location{$scaf}{$idx} = 'intron' if !$Location{$scaf}{$idx};
     }
  }

open annoOut,'>',$PolySSRFile.'_Annotation.txt';
open statOut,'>',$PolySSRFile.'_Annotation_Statistic.txt';
open IN,'<',$PolySSRFile;
while(<IN>){
  chomp;
  #($flank) = $_ =~ /Upstream\_(\d+)bp/ if /^SSRID/;
  ($cpid, $type, $str, @arr) = split/\t/, $_;
  $ref = $str;
  if(/^SSRID/){
    print annoOut $cpid."\t".$type."\t"."Location\t".$str."\t".join("\t", @arr)."\n";
    }
    else{
      ($str) = (split/\|/,$str)[1];
      ($scaf, $str) = (split/\:/,$str)[0,1];
      ($st, $end) = (split/\-/, $str)[0,1];
      $middle = sprintf("%.0f", ($end - $st)/2);
      $Location{$scaf}{$middle} = 'intergenic' if !$Location{$scaf}{$middle};
      print annoOut $cpid."\t".$type."\t".$Location{$scaf}{$middle}."\t".$ref."\t".join("\t", @arr)."\n";
      $Count{$Location{$scaf}{$middle}}++;
      }
  }
  close IN;
  close annoOut;

foreach (sort {$Count{$a} <=> $Count{$b}} keys %Count){
  chomp;
  print statOut $_."\t".$Count{$_}."\n";
  }
  close statOut;


