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
### Running Canu
###############
