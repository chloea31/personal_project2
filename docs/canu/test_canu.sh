#!/bin/bash

#########################################################
#########################################################
###       Nanopore sequence Assembly using Canu       ###
#########################################################
#########################################################


###################################
# Activating the conda environment
###################################

# conda activate canu


###############
### Variable initialization
###############

WORK_DIR="$PWD"


###############
### Testing Canu
###############

/home/caujoulat/miniforge3/envs/canu/bin/canu

/home/caujoulat/miniforge3/envs/canu/bin/canu -options

###############
### Canu: Quick start
###############

curl -L -o pacbio.fastq http://gembox.cbcb.umd.edu/mhap/raw/ecoli_p6_25x.filtered.fastq
md5sum pacbio.fastq
md5sum ecolk12mg1655_R10_3_guppy_345_HAC.fastq 

canu -p ecoli -d ecoli-pacbio genomeSize=4.8m -pacbio pacbio.fastq redMemory=6 oeaMemory=6

canu -p ecoli \
    -d ecoli-oxford \
    genomeSize=4.8m \
    maxInputCoverage=100 \
    -nanopore ecolk12mg1655_R10_3_guppy_345_HAC.fastq.gz \
    maxMemory=6 \
    redMemory=6 \
    oeaMemory=6


curl -L -o ecoli.fastq https://sra-pub-src-1.s3.amazonaws.com/SRR10971019/m54316_180808_005743.fastq.1

canu \
    -p asm -d ecoli_hifi \
    genomeSize=4.8m \
    -pacbio-hifi ecoli.fastq


curl -L -o K12.parental.fasta https://gembox.cbcb.umd.edu/triobinning/example/k12.12.fasta
curl -L -o O157.parental.fasta https://gembox.cbcb.umd.edu/triobinning/example/o157.12.fasta
curl -L -o F1.fasta https://gembox.cbcb.umd.edu/triobinning/example/pacbio.fasta

md5sum K12.parental.fasta
md5sum O157.parental.fasta
md5sum F1.fasta

canu \
    -p asm -d ecoliTrio \
    genomeSize=5m \
    -haplotypeK12 K12.parental.fasta \
    -haplotypeO157 O157.parental.fasta \
    -pacbio F1.fasta \
    maxMemory=6 \
    redMemory=6 \
    oeaMemory=6

### Co-assembling the datasets
canu \
    -p asm -d ecoliHap \
    genomeSize=5m \
    corOutCoverage=200 "batOptions=-dg 3 -db 3 -dr 1 -ca 500 -cp 50" \
    -pacbio F1.fasta \
    maxMemory=6 \
    redMemory=6 \
    oeaMemory=6
# does not work (probably due to a lack of computational resources)


curl -L -o mix.tar.gz http://gembox.cbcb.umd.edu/mhap/raw/ecoliP6Oxford.tar.gz
tar xvzf mix.tar.gz

canu \
    -p ecoli -d ecoli-mix \
    genomeSize=4.8m \
    -pacbio pacbio.part?.fastq.gz \
    -nanopore oxford.fasta.gz \
    maxMemory=6 \
    redMemory=6 \
    oeaMemory=6
# down not work: might be due to either computational resources, or issues related to installation of the package

canu -correct \
    -p ecoli -d ecoli \
    genomeSize=4.8m \
    -pacbio  pacbio.fastq \
    maxMemory=6 \
    redMemory=6 \
    oeaMemory=6
    # same as before: overlap fails (may be due to lack of computational resources or installation issues)

canu -trim \
    -p ecoli -d ecoli \
    genomeSize=4.8m \
    -corrected -pacbio ecoli/ecoli.correctedReads.fasta.gz

canu \
    -p ecoli -d ecoli-erate-0.039 \
    genomeSize=4.8m \
    correctedErrorRate=0.039 \
    -trimmed -corrected -pacbio ecoli/ecoli.trimmedReads.fasta.gz

canu \
    -p ecoli -d ecoli-erate-0.075 \
    genomeSize=4.8m \
    correctedErrorRate=0.075 \
    -trimmed -corrected -pacbio ecoli/ecoli.trimmedReads.fasta.gz

### Try uncorrected ONT assembly
canu \
    -p ecoli -d ecoli-oxford-uncorrected \
    genomeSize=4.8m \
    -untrimmed correctedErrorRate=0.12 maxInputCoverage=100 'batOptions=-eg 0.10 -sb 0.01 -dg 2 -db 1 -dr 3' \
    -pacbio-hifi ecolk12mg1655_R10_3_guppy_345_HAC.fastq

### Assembling low coverage datasets
curl -L -o yeast.20x.fastq.gz http://gembox.cbcb.umd.edu/mhap/raw/yeast_filtered.20x.fastq.gz

canu \
    -p asm -d yeast \
    genomeSize=12.1m \
    correctedErrorRate=0.105 \
    -pacbio yeast.20x.fastq.gz