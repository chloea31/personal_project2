#!/bin/bash

###############################################################
###############################################################
###   Genome Assembly using SOAPdenovo 2 FOR BAOSHAN DATA   ###
###############################################################
###############################################################


###################################
# Activating the conda environment
###################################

# conda activate soapdenovo


###############
### Variable initialization
###############

WORK_DIR="$PWD" # working directory

###############
### Running the tool
###############

SOAPdenovo-127mer all -s data/baoshan/configFile.config -K 67 -R -o 67mer 1>ass.log 2>ass.err -p 4 -a 60G
