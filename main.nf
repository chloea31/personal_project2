#!/usr/bin/env nextflow

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*       ANALYSIS OF GENOMIC DATA FROM BAOSHAN MIMIVIRUS      */
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


// How to run the pipeline in personal_project2/ repository:
// 1) Activate the conda environment to get nextflow: conda activate nextflow
// 2) Run the following command-line: nextflow run main.nf -with-conda -ansi-log false

// Declare synthax version
nextflow.enable.dsl=2 


process Prefetch { 

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses/'

    publishDir "${workflow.projectDir}/data/baoshan/prefetch"

    input: // choose its name, not its value, so no whole path here
        val accession 

    output: // choose its value, not its name, as return function in Python 
    // the pipeline needs to know where to take the files in the work/ directory
        path "${accession}" // the output is the folder itself
        val "${accession}"

    script:
    """
    prefetch ${accession}
    """
}

process FasterqDump {

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses/'

    publishDir "${workflow.projectDir}/data/baoshan/prefetch/${accession}"

    input:
        path sra_folder
        val accession

    output:
        path "*.fastq.gz" // returns a list of all fastq files in a single list in the current directory (of the process)
    // indicates where I have to take the files in the repository of the process

    script:
    """
    fasterq-dump ${sra_folder} --split-3 --threads 1
    gzip *.fastq
    """
}

process QC {

    conda '/home/caujoulat/miniforge3/envs/qc'

    publishDir "${workflow.projectDir}/reports/qc_results/baoshan"

    input:
        path fastq

    output:
        path "*.html"

    script:
    """
    fastqc ${fastq}
    """
}

workflow {
    println(workflow.commandLine)
    println(workflow.start)
    println(workflow.projectDir)
    println(workflow.launchDir)
    println(workflow.homeDir)
    accessions = Channel
        .fromPath("${workflow.projectDir}/data/baoshan/SRR_Acc_List.txt")
        .splitText()
        .map { it.trim() } // Clean up whitespace
    (sra_folders, accessions) = Prefetch(accessions)
    fastq_files = FasterqDump(sra_folders, accessions)
    qc_fastq_files = QC(fastq_files)
}