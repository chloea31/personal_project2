#!/bin/bash

#########################################################
#########################################################
###   Genome Assembly using SPADES FOR BAOSHAN DATA   ###
#########################################################
#########################################################


###################################
# Activating the conda environment
###################################

# conda activate spades


###############
### Variable initialization
###############

WORK_DIR=. # working directory
DATA_R1=./work/06/31d5d88fb6340c7c7d463fa0c76b0d/SRR30485660_1.fastq.gz
DATA_R2=./work/06/31d5d88fb6340c7c7d463fa0c76b0d/SRR30485660_2.fastq.gz

###############
### Running SPAdes
###############

echo ">running spades"
echo ${DATA_R1}
echo ${DATA_R2}
spades.py -1 ${DATA_R1} \
    -2 ${DATA_R2} \
    -k 67 \
    -o ${WORK_DIR}/reports/baoshan_results/illumina/genome_assembly/spades
