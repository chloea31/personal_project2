#!/bin/bash

##########################################
##########################################
### Downloading data from SRA database ###
##########################################
##########################################


###################################
# Activating the conda environment
###################################

# conda activate download_data_viruses


###############
### Variable initialization
###############

WORK_DIR=/mnt/c/Users/chloe/Documents/Bioinformatique/personal_project2


###################################
# Data collection
###################################
echo ">downloading the datasets"

sed -i 's/\r$//' $WORK_DIR/data/baoshan/SRR_Acc_List.txt
for i in $(cat $WORK_DIR/data/baoshan/SRR_Acc_List.txt); 
do
    echo $i
    echo "fastq-dump $i"
    fastq-dump --gzip --split-files --outdir $WORK_DIR/data/baoshan/ "$i"
done 
