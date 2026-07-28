#!/usr/bin/env nextflow

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*       ANALYSIS OF GENOMIC DATA FROM BAOSHAN MIMIVIRUS      */
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


// Command-line in personal_project2/ repository: nextflow run main.nf -with-conda -ansi-log false

// Declare synthax version
nextflow.enable.dsl=2 



process downloadFiles { 

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses/'

    publishDir "${workflow.projectDir}/data/baoshan/prefetch"

    input: // choose its name, not its value, so no whole path here
        path text_file

    output: // choose its value, not its name, as return function in Python 
    // the pipeline needs to know where to take the files in the work/ directory
        path "prefetch/*" 

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
    accessions = Channel.of("${workflow.projectDir}/data/baoshan/SRR_Acc_List_v1.txt")
    data = downloadFiles(accessions)
}