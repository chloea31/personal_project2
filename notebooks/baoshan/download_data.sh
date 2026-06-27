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


###################################
# Downloading data
###################################

for i in $(cat ./data/baoshan/SRR_Acc_List.txt); 
do
    echo $i
done 
