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

WORK_DIR="$PWD" # working directory
DATA_R1=${WORK_DIR}/work/14/fdb045347d47b0b34804898c7a2243/SRR30485660_1.fastq.gz
DATA_R2=${WORK_DIR}/work/14/fdb045347d47b0b34804898c7a2243/SRR30485660_2.fastq.gz

###############
### Running SPAdes
###############

echo ">running spades"
echo ${DATA_R1}
echo ${DATA_R2}
spades.py -1 ${DATA_R1} \
    -2 ${DATA_R2} \
    -k 67 \
    -m 8 \
    -o ${WORK_DIR}/reports/baoshan_results/illumina/genome_assembly/spades
