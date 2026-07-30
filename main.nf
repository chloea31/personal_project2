#!/usr/bin/env nextflow

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*       ANALYSIS OF GENOMIC DATA FROM BAOSHAN MIMIVIRUS      */
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


// Command-line in personal_project2/ repository: nextflow run main.nf -with-conda -ansi-log false

// Declare synthax version
nextflow.enable.dsl=2 


process Prefetch { 

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses/'

    // publishDir "${workflow.projectDir}/data/baoshan/prefetch"

    input: // choose its name, not its value, so no whole path here
        val accession 

    output: // choose its value, not its name, as return function in Python 
    // the pipeline needs to know where to take the files in the work/ directory
        path "${accession}" // the output is the folder itself

    script:
    """
    prefetch ${accession}
    """
}

process FasterqDump {

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses/'

    // publishDir "${workflow.projectDir}/data/baoshan/prefetch"

    input:
        path sra_folder

    output:
        path "*.fastq.gz" // returns a list of all fastq files in a single list in the current directory 

    script:
    """
    fasterq-dump ${sra_folder} --split-3 --threads 1 | gzip -v *.fastq.gz
    """
}

workflow {
    println(workflow.commandLine)
    println(workflow.start)
    println(workflow.projectDir)
    println(workflow.launchDir)
    println(workflow.homeDir)
    accessions = Channel
        .fromPath("${workflow.projectDir}/data/baoshan/SRR_Acc_List_v1.txt")
        .splitText()
        .map { it.trim() } // Clean up whitespace
    sra_folders = Prefetch(accessions)
    fastq_files = FasterqDump(sra_folders)
}