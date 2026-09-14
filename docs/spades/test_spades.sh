#!/bin/bash

###################################################
###################################################
###  Test Data Quality Control for short reads  ###
###################################################
###################################################


###################################
# Activating the conda environment
###################################

# conda activate spades


###############
### Variable initialization
###############

WORK_DIR="$PWD" # working directory

###############
### Testing the tool
###############

spades.py --test # => ok here

###############
### Useful one-liners
###############

spades.py \
    -1 /home/caujoulat/miniforge3/envs/spades/share/spades/test_dataset/ecoli_1K_1.fq.gz \
    -2 /home/caujoulat/miniforge3/envs/spades/share/spades/test_dataset/ecoli_1K_2.fq.gz \
    -o output_folder
