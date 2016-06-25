#!/bin/bash
# AUTHOR: DEBJIT RAY
# DATE: 09/12/2013
# DESCRIPTION: RUNS ALL THE PROCESSING STEPS
# PLATFORM: HPC [COPY THIS FILE ON THE HPC AND RUN ON THE HPC HOME] AS $ sh 0C.Processing.sh
# NOTES: [FILE1]=SRR527218 AND [FILE2]=SRR527219, TRIMMED FILES FROM THE PREVIOUS STEPS SRR527218_TRIMMED REFFERED AS SSRR527218 AND SRR527219_TRIMMED REFFERED AS SSRR527219

# EXPORT THE BIN2 PATH
export PATH=$HOME/bin2:$PATH

# MAKING THE OUT FOLDER
mkdir Sequencing/OUT

## LINKING THE GTF FILE
echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Annotation/Genes/genes.gtf`

# ** BOWTIE 1 [COMMENT THE LINES UPTO 'END OF BOWTIE1' WHILE USING BOWTIE2]
## LINKING THE PRE-BUILT BOWTIE1 INDEX FILES
echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/BowtieIndex/genome.1.ebwt`
echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/BowtieIndex/genome.2.ebwt`
echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/BowtieIndex/genome.3.ebwt`
echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/BowtieIndex/genome.4.ebwt`
echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/BowtieIndex/genome.rev.1.ebwt`
echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/BowtieIndex/genome.rev.2.ebwt`

# RUNNING TOPHAT ON THE TWO SEQUENCES WITH BOWTIE1 #
echo `tophat --bowtie1 -p 8 -G genes.gtf -o Sequencing/OUT/SRR527218_thout genome Sequencing/SRR527218.fastq`
echo `tophat --bowtie1 -p 8 -G genes.gtf -o Sequencing/OUT/SRR527219_thout genome Sequencing/SRR527219.fastq`
# ** END OF BOWTIE1

# RUNNING TOPHAT ON THE TWO SEQUENCES WITH BOWTIE1 FOR STRAND SPECIFIC PROTOCOL (CHOOSE THE STRAND)#
#echo `tophat --bowtie1 -p 8 -G genes.gtf -o Sequencing/OUT/SRR527218_thout --library-type=fr-firststrand genome Sequencing/SRR527218.fastq`
#echo `tophat --bowtie1 -p 8 -G genes.gtf -o Sequencing/OUT/SRR527219_thout --library-type=fr-firststrand genome Sequencing/SRR527219.fastq`


# ** BOWTIE 2 [COMMENT THE LINES UPTO 'END OF BOWTIE2' WHILE USING BOWTIE1]
## LINKING THE PRE-BUILT BOWTIE2 INDEX FILES
#echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/Bowtie2Index/genome.1.bt2`
#echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/Bowtie2Index/genome.2.bt2`
#echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/Bowtie2Index/genome.3.bt2`
#echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/Bowtie2Index/genome.4.bt2`
#echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/Bowtie2Index/genome.rev.1.bt2`
#echo `ln -s ./Mus_musculus/Ensembl/NCBIM37/Sequence/Bowtie2Index/genome.rev.2.bt2`

# RUNNING TOPHAT ON THE TWO SEQUENCES WITH BOWTIE2 #
#echo `tophat -p 8 -G genes.gtf -o Sequencing/OUT/SRR527218_thout genome Sequencing/SRR527218.fastq`
#echo `tophat -p 8 -G genes.gtf -o Sequencing/OUT/SRR527219_thout genome Sequencing/SRR527219.fastq`
# ** END OF BOWTIE2

# RUNNING TOPHAT ON THE TWO SEQUENCES WITH BOWTIE2 USING UNIQUE MAPPING [COMMENT THE PREVIOUS TWO LINE AND UNCOMMNET THE TWO LINES BELOW]#
# echo `tophat -p 8 -g 1 -G genes.gtf -o Sequencing/OUT/SRR527218_thout genome Sequencing/SRR527218.fastq`
# echo `tophat -p 8 -g 1 -G genes.gtf -o Sequencing/OUT/SRR527218_thout genome Sequencing/SRR527218.fastq`




## RUNNING CUFFLINKS ON THE TWO SEQUENCES ##
echo `cufflinks -p 8 -o Sequencing/OUT/SRR527218_clout Sequencing/OUT/SRR527218_thout/accepted_hits.bam`
echo `cufflinks -p 8 -o Sequencing/OUT/SRR527219_clout Sequencing/OUT/SRR527219_thout/accepted_hits.bam`

###  RUNNING CUFFMERGE ON THE TWO SEQUENCES ###
echo `cuffmerge -g genes.gtf -s Mus_musculus/Ensembl/NCBIM37/Sequence/WholeGenomeFasta/genome.fa -p 8 assemblies.txt`


#### RUNNING CUFFDIFF ON THE TWO SEQUENCES####
echo `cuffdiff -o diff_out -b Mus_musculus/Ensembl/NCBIM37/Sequence/WholeGenomeFasta/genome.fa -p 8 -L WT,MUT -u merged_asm/merged.gtf Sequencing/OUT/SRR527218_thout/accepted_hits.bam Sequencing/OUT/SRR527219_thout/accepted_hits.bam`


## REMOVE THE INDEX FILES
echo `rm -r genes.gtf`
echo `rm -r genome.*`