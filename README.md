=====================================================================================================================
CandiSSR: An efficient pipeline used for identifying candidate polymorphic SSRs based on multiple assembled sequences
=====================================================================================================================

Introduction
------------
Simple sequence repeats (SSRs) (also called microsatellites), consisting of repeated sequences of 2~6 bp in length, have been widely used in QTL analysis, evaluation of genetic variation and construction of genetic linkage maps. Recent adcances in next generation sequencing have rapidly accelerated the genome/transcriptomic sequencing projects in serveral species. Accordingly, lots of SSRs were also detected among them; however, due to the low efficiency of traditional experimental methods, few avaliable polymorphic SSRs of them are currently identified. Thus, we here had developed a new bioinformatics pipeline, CandiSSR, to automatically search the candidate polymorphic SSRs of a given species or genus based on their given assembled sequences. With this pipeline, user can detect polymorphic SSRs from a control file containing multiple assembled sequences of a given species or genus.

Installation
------------
Dependent software and packages
 1) Perl
    You should have perl installed, if not, it is freely available at https://www.perl.org/.

 2) MISA
    It is freely available at http://pgrc.ipk-gatersleben.de/misa/.

 3) NCBI Blast
    Note: The NCBI Blastall package (version: 2.2.26) works well. 
    It is freely available at ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.26/.

 4) Bioperl packages (SearchIO and getopt)
    It is freely available at http://bioperl.org/DIST/.

 5) ClustalW
    It is freely available at: http://www.clustal.org/download/current/.

 6) Primer3
    It is freely available at: http://primer3.sourceforge.net/.

Alternatively, you can download all the requirments from our website at: http://www.plantkingdomgdb.com/CandiSSR/requirments/

After downloading and installing all the dependent software and packages
You can install the pipeline fllowing the below steps:
 1) download the file CandiSSR.tar.gz
 2) unpack CandiSSR.tar.gz
 3) cd CandiSSR
 4) sh setup.sh
The setup script will ask you a few basic questions to setup CandiSSR.

A more detail installation steps please refers to: http://www.plantkingdomgdb.com/CandiSSR/install_on_linux.html

Homepage
--------
http://www.plantkingdomgdb.com/CandiSSR/

Contact
-------
Dr. En-Hua Xia (xiaenhua@gmail.com) and CC to Dr. Li-Zhi Gao (lgao@mail.kib.ac.cn)
Plant Germplasm and Genomics Center in Southwest China
Germplasm Bank of Wild Species, Kunming Institute of Botany
Chinese Academy of Sciences, Kunming 650201, China
