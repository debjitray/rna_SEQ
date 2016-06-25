#!/bin/bash
# AUTHOR: DEBJIT RAY
# DATE: 09/12/2013
# DESCRIPTION: INSTALLS ALL THE REUIRED SOFTWARES [NEED TO DO IT ONCE]
# PLATFORM: HPC [COPY THIS FILE ON THE HPC AND RUN ON THE HPC HOME] AS $ sh 0.SoftwareInstaller.sh

# MAKING THE BIN2 FOLDER
mkdir bin2

# FOR FASTQC INSTALLATION [UPDATE THE FOLDERS WITH THE LATEST VERSION]
echo `wget 'http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.10.1.zip'`
echo `unzip fastqc_v0.10.1.zip`
echo `scp -r FastQC/* $HOME/bin2`
chmod 755 bin2/fastqc
echo `rm -r fastqc_v0.10.1.zip`
echo `rm -r FastQC`

# FOR FASTX TOOLKIT INSTALLATION [UPDATE THE FOLDERS WITH THE LATEST VERSION]
mkdir TEMP
cd TEMP
echo `wget 'http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2'`
echo `tar jxf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2`
echo `scp -r $HOME/TEMP/bin/* $HOME/bin2`
cd
echo `rm -r TEMP`

# FOR BOWTIE1 INSTALLATION [UPDATE THE FOLDERS WITH THE LATEST VERSION]
echo `wget 'http://sourceforge.net/projects/bowtie-bio/files/bowtie/0.12.9/bowtie-0.12.9-linux-x86_64.zip/download'`
echo `unzip bowtie-0.12.9-linux-x86_64.zip`
echo `cp bowtie-0.12.9/bowtie $HOME/bin2`
echo `cp bowtie-0.12.9/bowtie-build $HOME/bin2`
echo `cp bowtie-0.12.9/bowtie-inspect $HOME/bin2`
echo `rm -r bowtie-0.12.9*`

# FOR BOWTIE2 INSTALLATION [UPDATE THE FOLDERS WITH THE LATEST VERSION]
echo `wget 'http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.1.0/bowtie2-2.1.0-linux-x86_64.zip/download'`
echo `unzip bowtie2-2.1.0-linux-x86_64.zip`
echo `cp bowtie2-2.1.0/bowtie2* $HOME/bin2`
echo `rm -r bowtie2-2.1.0*`

# FOR TOPHAT INSTALLATION [UPDATE THE FOLDERS WITH THE LATEST VERSION]
echo `wget 'http://tophat.cbcb.umd.edu/downloads/tophat-2.0.2.Linux_x86_64.tar.gz'`
echo `gunzip tophat-2.0.2.Linux_x86_64.tar.gz`
echo `tar -xvf tophat-2.0.2.Linux_x86_64.tar`
echo `cp tophat-2.0.2.Linux_x86_64/* $HOME/bin2`
echo `rm -r tophat-2.0.2.Linux_x86_64*`

# FOR CUFFLINK INSTALLATION [UPDATE THE FOLDERS WITH THE LATEST VERSION]
echo `wget 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-2.0.2.Linux_x86_64.tar.gz'`
echo `gunzip cufflinks-2.0.2.Linux_x86_64.tar.gz`
echo `tar -xvf cufflinks-2.0.2.Linux_x86_64.tar`
echo `cp cufflinks-2.0.2.Linux_x86_64/* $HOME/bin2`
echo `rm -r cufflinks-2.0.2.Linux_x86_64*`


# FOR SAMTOOLS INSTALLATION [UPDATE THE FOLDERS WITH THE LATEST VERSION]
echo `wget 'http://sourceforge.net/projects/samtools/files/samtools/0.1.18/samtools-0.1.18.tar.bz2/download'`
echo `tar jxf samtools-0.1.18.tar.bz2`
cd samtools-0.1.18
echo `make`
echo `cp samtools $HOME/bin2`
cd
echo `rm -r samtools-0.1.18*`


# FOR SRATOOLKIT [UPDATE THE FOLDERS WITH THE LATEST VERSION]
echo `wget 'http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.3.3-3/sratoolkit.2.3.3-3-centos_linux64.tar.gz'`
echo `tar xvf sratoolkit.2.3.3-3-centos_linux64.tar.gz`
echo `mv sratoolkit.2.3.3-3-centos_linux64 bin2/`
echo `rm -r sratoolkit.2.3.3-3-centos_linux64*`


export PATH=$HOME/bin2:$PATH



