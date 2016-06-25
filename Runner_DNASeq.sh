#!/bin/bash
# RUN ON THE HPC ***
export PATH=$HOME/bin:$PATH


# Download chrIII.fa from http://hgdownload.cse.ucsc.edu/goldenPath/ce6/chromosomes/ [chrIII.fa.gz]
# RAW reads form the Watts lab stored here

mkdir Index

# CREATING BOWTIE INDEX FOR THE CHROMOSOME III
echo `bowtie2-build chrIII.fa Index/Cele`

mkdir Alligned

echo 'Working on the allignment'
# CREATING THE ALLIGNMENT FILES
# 6 Raw fastq files were from Watts lab, Sample_6_PE1.fastq is the WILD type, ohter 5 are the mutants
# Bowtie 2 was used to index the C. elegans reference genome and to align our fastq sequencing reads to this reference.
# Bowtie 2 is an ultrafast aligner that outputs a SAM (Sequence Alignment/Map).
# SIZE of each fastq = ~1.5GB, PLatform is Illumina miseq
echo `bowtie2 -x Index/Cele -U RAW/Sample_1-wa28_PE1.fastq -S Alligned/eg1.sam`
echo `bowtie2 -x Index/Cele -U RAW/Sample_2-wa3_PE1.fastq -S Alligned/eg2.sam`
echo `bowtie2 -x Index/Cele -U RAW/Sample_3-wa2_PE1.fastq -S Alligned/eg3.sam`
echo `bowtie2 -x Index/Cele -U RAW/Sample_4-wa20_PE1.fastq -S Alligned/eg4.sam`
echo `bowtie2 -x Index/Cele -U RAW/Sample_5-wa24_PE1.fastq -S Alligned/eg5.sam`
echo `bowtie2 -x Index/Cele -U RAW/Sample_6_PE1.fastq -S Alligned/eg6.sam`


# SAM TO BAM CONVERSION
echo 'Working SAM to BAM converion'
cd Alligned
echo `samtools view -bS eg1.sam>eg1.bam`
echo `samtools view -bS eg2.sam>eg2.bam`
echo `samtools view -bS eg3.sam>eg3.bam`
echo `samtools view -bS eg4.sam>eg4.bam`
echo `samtools view -bS eg5.sam>eg5.bam`
echo `samtools view -bS eg6.sam>eg6.bam`

# BAM to SORTED BAM CONVERSION
echo 'Working BAM to SORTED BAM CONERSION'
echo `samtools sort eg1.bam eg1_sorted`
echo `samtools sort eg2.bam eg2_sorted`
echo `samtools sort eg3.bam eg3_sorted`
echo `samtools sort eg4.bam eg4_sorted`
echo `samtools sort eg5.bam eg5_sorted`
echo `samtools sort eg6.bam eg6_sorted`

# Information regarding sequence quality and possible genotype was calculated using the 'samtools mpileup' command and stored in the BCF file format.
# Creates a index file chrIII.fa.fai
echo `samtools mpileup -uf /home/yelab/debjit_ray/DNA-Seq/chrIII.fa eg1_sorted.bam eg2_sorted.bam eg3_sorted.bam eg4_sorted.bam eg5_sorted.bam eg6_sorted.bam | bcftools view -bvcg - > var.raw.bcf`
# Variants were called and written to a VCF (Variant Call Format) file using the 'bcftools view' and 'vcfutils.pl' commands. 
# VCF is a widely used text file format storing information regarding variant position and sequence, sequence quality, and predicted genotype.
# .vcf is mainly used for visualization using IGV
echo `bcftools view var.raw.bcf | vcfutils.pl varFilter -D100 > var.flt.vcf `

cd ..

# DOWLOAD THE ANNOVAR SOFTWARE
# http://www.openbioinformatics.org/annovar/annovar_download_form.php
# DOWNLOAD and copy the contents to the 'bin' folder on HPC except the example and humandb folder
# export PATH=$HOME/bin:$PATH
# ANNOVAR software is used for the database creation and annotation

# DOWNLOADING THE C.Elegans Database
# C.elegans genome annotations were retrieved from the UCSC Genome Browser Annotation Database using the Perl-based software package ANNOVAR
echo `annotate_variation.pl -downdb -buildver ce6 gene celedb`
echo `annotate_variation.pl --buildver ce6 --downdb seq celedb/ce6_seq`
echo `retrieve_seq_from_fasta.pl celedb/ce6_refGene.txt -seqdir celedb/ce6_seq -format refGene -outfile celedb/ce6_refGeneMrna.fa`

cd Alligned

# ANNOVAR was used to convert our VCF files to ANNOVAR input files
echo `convert2annovar.pl -format vcf4 var.flt.vcf > output.avinput`
# Annotate variants
echo `annotate_variation.pl -geneanno output.avinput /home/yelab/debjit_ray/DNA-Seq/celedb/ -buildver ce6`

# ANNOVAR outputs one file annotating all variants indicating the genomic features they hit, and a second file indicating the amino acid changes for exonic variants. 
# For convenience, these files were combined into a single table using Microsoft Access.
# MAIN OUTPUT FILES:	output.avinput.variant_function
#						output.avinput.exonic_variant_function  [Only the exonic one annotated in this file]
# Uses these annoations ::	http://www.openbioinformatics.org/annovar/annovar_gene.html [Saved in the 1.Manuals]
#							http://www.openbioinformatics.org/annovar/annovar_input.html [Saved in the 1.Manuals]

# RUN ON THE HPC UPTO HERE ***
## PROCESSING STEPS

# Download IGV from http://www.broadinstitute.org/software/igv/log-in
# Click on the Click on the igv.jar [opens a GUI]
# In IGV select C.elegans (ce6) and chrIII
# Go to File>Load from File>var.flt.vcf [ This loads all the sorted bam files]

# Ref: http://gatkforums.broadinstitute.org/discussion/1268/how-should-i-interpret-vcf-files-produced-by-the-gatk#sthash.tKu3J8Dl.dpuf

# QUALITY SCORE:	The Phred scaled probability that a REF/ALT polymorphism exists at this site given sequencing data. 
#					Because the Phred scale is -10 * log(1-p), a value of 10 indicates a 1 in 10 chance of error, while a 100 indicates a 1 in 10^10 chance. 
#					These values can grow very large when a large amount of NGS data is used for variant calling. [Large score better quality]

# READ DEPTH:		While the sample-level (FORMAT) DP field describes the total depth of reads that passed the caller's internal quality control metrics (like MAPQ > 17, for example), 
#					the INFO field DP represents the unfiltered depth over all samples. 
#					Note though that the DP is affected by downsampling (-dcov), so the max value one can obtain for N samples with -dcov D is N * D
#					# READDEPTH is the one in FORMAT passed the quality score.

# RMSMappingQuality:	Root Mean Square of the mapping quality of the reads across all samples.
#						A measure of the variance of quality scores.
#						A conservative strategy is to set the minimum RMS mapping quality low, to detect SNPs even if there's only poor evidence for them. 
#						This will allow these suspect SNPs to disqualify neighboring SNPs in dense SNP regions. 
#						Then, out of the remaining SNPs, select higher quality SNPs by filtering based on the appropriate column of the pileup output.









