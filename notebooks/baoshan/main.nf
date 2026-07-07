#!/usr/bin/env nextflow

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*       ANALYSIS OF GENOMIC DATA FROM BAOSHAN MIMIVIRUS      */
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

// Declare synthax version
nextflow.enable.dsl=2 

// Initialize default parameters

// Getting help message

// Defining processes

process downloadFiles { 

    publishDir '${workflow.projectDir}/data/baoshan/prefetch'

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses'

    input:
        text_file

    output:
        path "${workflow.projectDir}/data/baoshan/prefetch"

    script:
    """
    prefetch --progress ${accession}
    """
}