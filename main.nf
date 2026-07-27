#!/usr/bin/env nextflow

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*       ANALYSIS OF GENOMIC DATA FROM BAOSHAN MIMIVIRUS      */
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


// Command-line: nextflow run main.nf -with-conda

// Declare synthax version
nextflow.enable.dsl=2 



process downloadFiles { 

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses/'

    publishDir '${workflow.projectDir}/data/baoshan/prefetch'

    input:
        path text_file

    output:
        //path "${workflow.projectDir}/data/baoshan/prefetch/*.sra"
        path "*.fastq.gz"

    script:
    """
    ${workflow.projectDir}/notebooks/baoshan/download_data.sh 
    """
}

workflow {
    println(workflow.projectDir)
    println(workflow.launchDir)
    accessions = Channel.of("${workflow.projectDir}/data/baoshan/SRR_Acc_List.txt")
    data = downloadFiles(accessions)
}