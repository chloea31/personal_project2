#!/bin/bash

###################################################
###################################################
###   Test Genome Assembly using SOAPdenovo 2   ###
###################################################
###################################################


###################################
# Activating the conda environment
###################################

# conda activate soapdenovo


###############
### Variable initialization
###############

WORK_DIR="$PWD" # working directory

###############
### Testing the tool
###############

SOAPdenovo-63mer

SOAPdenovo-63mer all -s configFile.config -K 63 -R -o graph_prefix ecoli

SOAPdenovo-127mer all -s configFile.config -K 127 -R -o 127mer 1>ass.log 2>ass.err # does not seem to work for these data

SOAPdenovo-63mer all -s configFile.config -K 50 -R -o 50mer 1>ass.log 2>ass.err

SOAPdenovo-127mer all -s configFile.config -K 100 -R -o 100mer 1_v100kmer>ass.log 2_v100kmer>ass.err