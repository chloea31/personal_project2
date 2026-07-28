#!/usr/bin/env nextflow

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*       ANALYSIS OF GENOMIC DATA FROM BAOSHAN MIMIVIRUS      */
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


// Command-line in personal_project2/ repository: nextflow run main.nf -with-conda

// Declare synthax version
nextflow.enable.dsl=2 



process downloadFiles { 

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses/'

    publishDir "${workflow.projectDir}/data/baoshan/prefetch"

    input:
        path text_file

    output: // the pipeline needs to know where to take the files in the work/ directory
        path "prefetch/*.fastq*" 

    script:
    """
    ${workflow.projectDir}/notebooks/baoshan/download_data.sh 
    """
}

workflow {
    println(workflow.commandLine)
    println(workflow.start)
    println(workflow.projectDir)
    println(workflow.launchDir)
    println(workflow.homeDir)
    accessions = Channel.of("${workflow.projectDir}/data/baoshan/SRR_Acc_List.txt")
    data = downloadFiles(accessions)
}