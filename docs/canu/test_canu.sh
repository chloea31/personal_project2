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