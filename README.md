CandiSSR: An efficient pipeline used for identifying candidate polymorphic SSRs based on multiple assembled sequences
=========

Introduction
------------
Simple sequence repeats (SSRs) (also called microsatellites), consisting of repeated sequences of 2~6 bp in length, have been widely used in QTL analysis, evaluation of genetic variation and construction of genetic linkage maps. Recent adcances in next generation sequencing have rapidly accelerated the genome/transcriptomic sequencing projects in serveral species. Accordingly, lots of SSRs were also detected among them; however, due to the low efficiency of traditional experimental methods, few avaliable polymorphic SSRs of them are currently identified. Thus, we here had developed a new bioinformatics pipeline, CandiSSR, to automatically search the candidate polymorphic SSRs of a given species or genus based on their given assembled sequences. With this pipeline, user can detect polymorphic SSRs from a control file containing multiple assembled sequences of a given species or genus.

Dependances
-------------------------------
 1) Perl</br>
    You should have perl installed, if not, it is freely available at https://www.perl.org/.

 2) MISA</br>
    It is freely available at http://pgrc.ipk-gatersleben.de/misa/.

 3) NCBI Blastall</br>
    Note: The NCBI Blastall package (version: 2.2.26) <b>NOT</b> ncbi-blast+ works well.</br>
    It is freely available at ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.26/.

 4) Bioperl packages (SearchIO and getopt)</br>
    It is freely available at http://bioperl.org/DIST/.

 5) ClustalW</br>
    It is freely available at: http://www.clustal.org/download/current/.

 6) Primer3 (version 2.3.6)</br>
    It is freely available at: http://primer3.sourceforge.net/.

Alternatively, you can download all the requirments from our website at: http://www.plantkingdomgdb.com/CandiSSR/requirments/

Installation
------------
 1) download the file CandiSSR.tar.gz
 2) unpack CandiSSR.tar.gz
 3) cd CandiSSR
 4) bash setup.sh
 
 The setup script will ask you a few basic questions to setup CandiSSR.

A more detail installation steps please refers to: http://www.plantkingdomgdb.com/CandiSSR/install_on_linux.html

Homepage
--------
http://www.plantkingdomgdb.com/CandiSSR/

Run the program
---------------
Typing perl $DIRECTORY_OF_CandiSSR/CandiSSR.pl with below options.

<b>Usage:</b>

perl CandiSSR.pl -i Ctg_file -o CandiSSR_Run -p Prefix -l FlankingLen -s Identity -c Coverage -t Cpu [-h]

  <b>Options:</b></br>
&emsp;-i&emsp;<str>&emsp;The data config file. *Must be given</br>
&emsp;-o&emsp;<str> &emsp;Name of directory for output.  [default: CandiSSR_Run]</br>
 -p\t<str>   The prefix of output file. [default: CandiSSR_Output]</br>
 -l   <int>   The flanking sequence length of SSRs. [default: 100]</br>
 -e   <int>   Blast evalue cutoff. [default: 1e-10]</br>
 -s   <int>   Blast identity cutoff. [default: 95]</br>
 -c   <int>   Blast coverage cutoff. [idefault: 95]</br>
 -t   <int>   Number of CPU used in blast searches. [default: 10]</br>
 -skipPE      Skip Primer Evaluation (PE) step, which is extremely time-consuming</br>
 -clean       Clean the output directory and only retain the CandiSSR file</br>
 -h           Show this help and exit</br>

<b>Data Config File Format (split by space):</b>

   1) The data for each species/individual must be placed in one row with two columns: </br>
      col1: Name of Species/individual; </br>
      col2: The path to data file; </br>
   2) They should be splited by space; </br>
   3) !!!!Very important!!!! </br>
      One species or individual must be selected as reference;</br> 
      Meanwhile, its species name must be set with "Ref" in the first column.</br>

<b>Example</b> </br>
   #Name          Path_to_data_files</br> 
    Ref          ./sample_data/COL.fasta </br>
    CRD          ./sample_data/CRD.fasta </br>
    CSI          ./sample_data/CSI.fasta </br>
    CTA          ./sample_data/CTA.fasta </br>
    ......          ......
    
 Note: Lines begin with "#" will be ignored! 

For example, you can identify the candidate polymorphic SSRs for genus Camellia from the previously published 4 Camellia transcriptomic data1,2 like below. 

$ perl CandiSSR.pl -i sample_data/Camellia_CandiSSR.ctl -o tea -p tea_est 

Contact
-------
Dr. En-Hua Xia (xiaenhua@gmail.com) and CC to Dr. Li-Zhi Gao (lgao@mail.kib.ac.cn)

Plant Germplasm and Genomics Center in Southwest China

Germplasm Bank of Wild Species, Kunming Institute of Botany

Chinese Academy of Sciences, Kunming 650201, China

Citation
--------
Please cite us if you use CandiSSR:

Xia EH, Yao QY, Zhang HB, Jiang JJ, Zhang LP and Gao LZ. (2016). CandiSSR: An efficient pipeline used for identifying candidate polymorphic SSRs based on multiple assembled sequences. Front. Plant Sci. 6:1171. doi: 10.3389/fpls.2015.01171
