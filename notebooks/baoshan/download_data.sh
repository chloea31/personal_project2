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
    if [ ! -d $WORK_DIR/data/baoshan/$i ]; then
        mkdir -p "$WORK_DIR/data/baoshan/$i"
    fi 
    echo "fastq-dump $i"
    fastq-dump --gzip \
        --split-files \
        --readids \
        --dumpbase \
        --clip \
        --outdir $WORK_DIR/data/baoshan/$i \
        --log-level 5 "$i"
done 
# According to the article, the data provided in SRA database would be already uploaded skipping technicals, so we might want to
# not include the --skip-technicals option here.

# Cannot download all the data => Try to figure out what is going wrong
# Command-line launched without all of the previous arguments:
# fastq-dump --gzip --split-files --readids <accession>

