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

