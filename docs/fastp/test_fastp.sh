#!/bin/bash

###################################################
###################################################
###  Test Data Quality Control for short reads  ###
###################################################
###################################################


###################################
# Activating the conda environment
###################################

# conda activate env_qc_data


###############
### Variable initialization
###############

WORK_DIR=/mnt/c/Users/chloe/Documents/Bioinformatique/personal_project2
DATA_DIR=/mnt/c/Users/chloe/Documents/Bioinformatique/personal_project2/docs/fastp

###############
### Running the command-line
###############

## In the /mnt/c/Users/chloe/Documents/Bioinformatique/personal_project2/docs/fastp repository
fastp -i R1.fq.gz -I R2.fq.gz -o out.R1.fq.gz -O out.R2.fq.gz
