#!/bin/bash

###################################################
###################################################
### Test Downloading data from the SRA database ###
###################################################
###################################################


# Link of the tutorial: https://bioinformatics.ccr.cancer.gov/docs/b4b/Module1_Unix_Biowulf/Lesson6/

# Activating the conda environment: conda activate download_data_viruses

# Using fastq-dump
mkdir biostar_class
cd biostar_class
mkdir sra_data
cd sra_data
fastq-dump SRR1553607
fastq-dump --split-files SRR1553607
fastq-dump --split-files -X 10000 SRR1553607 --outdir SRR1553607_subset
fastq-dump --help

# Using seqkit stat
seqkit --help
seqkit stat SRR1553607_1.fastq

# Using fasterq-dump
fasterq-dump SRR1553607

# Using prefetch
mkdir prefetch
cd prefetch
prefetch SRR1553607 
ls -l
fasterq-dump SRR1553607 

# Navigating NCBI SRA
# In ./docs/sratoolkit/downloading_data_from_SRA/ncbi_sra:
head -n 3 runaccessions.txt > runids.txt

# Using the "parallel" tool for automating downloads
sudo apt install moreutils
cat runids.txt | parallel -j 1 fastq-dump -X 10000 --split-files {}
cat runids.txt | parallel fastq-dump -X 10000 --split-files

