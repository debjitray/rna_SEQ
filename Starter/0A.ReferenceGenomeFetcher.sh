#!/bin/bash
# AUTHOR: DEBJIT RAY
# DATE: 09/12/2013
# DESCRIPTION: OBTAINS THE REFERENCE GENOME
# PLATFORM: LOCAL MACHINE $ sh 0A.ReferenceGenomeFetcher.sh
# REFERENCE GENOME USED:: Mus_musculus_NCBI_build37.1

# GET THE REFRENCE GENOME DIRECLT FROM IGENOME WEBSITE
echo` wget 'ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Mus_musculus/NCBI/build37.1/Mus_musculus_NCBI_build37.1.tar.gz'`

# COPY IT TO THE HPC HOME
echo `scp -r Mus_musculus_NCBI_build37.1.tar.gz debjit_ray@hpclogin1.wsu.edu:/home/yelab/debjit_ray/`

# REMOVE THE COPY FROM LOCAL MACHINE
echo `rm –r Mus_musculus_NCBI_build37.1*`
	
# UNZIP THE FOLDER ON THE HPC
echo `ssh debjit_ray@hpclogin1.wsu.edu "tar xvf Mus_musculus_NCBI_build37.1.tar.gz"`

# REMOVE THE TAR FILE
echo `ssh debjit_ray@hpclogin1.wsu.edu "rm -r Mus_musculus_NCBI_build37.1.tar.gz"`