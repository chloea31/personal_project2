#!/usr/bin/env nextflow

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*       ANALYSIS OF GENOMIC DATA FROM BAOSHAN MIMIVIRUS      */
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


// How to run the pipeline in personal_project2/ repository:
// 1) Activate the conda environment to get nextflow: conda activate nextflow
// 2) Run the following command-line: nextflow run -resume main.nf -with-conda

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

process FASTP {

    conda '/home/caujoulat/miniforge3/envs/fastp'

    publishDir "${workflow.projectDir}/reports/baoshan_results/fastp"

    input:
        path fastq_R1
        path fastq_R2
        val accession

    output:
        path "*.html"
        path "*.fq.gz"

    script:
    """
    r1 = fastq_R1.getBaseName
    fastp -i "${fastq_R1}" -I "${fastq_R2}" -o "${fastq_R1.baseName}.fq.gz" -O "${fastq_R2.baseName}.fq.gz"
    """
}

process QC {

    conda '/home/caujoulat/miniforge3/envs/qc'

    publishDir "${workflow.projectDir}/reports/baoshan_results/qc"

    input:
        path fastq

    output:
        path "*.html"

    script:
    """
    fastqc ${fastq}
    """
}

process MultiQC {

    conda '/home/caujoulat/miniforge3/envs/multiqc'

    publishDir "${workflow.projectDir}/reports/baoshan_results/multiqc"

    input:
        path html_report

    output:
        path "*.html"

    script:
    """
    echo ${html_report} >> 
    multiqc --file-list 
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
        .splitText() // Reads the file and generates 1 element/input per row
        .map { it.trim() } // Clean up whitespace
    (sra_folders, accessions) = Prefetch(accessions)
    fastq_files = FasterqDump(sra_folders, accessions) // returns a list of 2 fastq files each time (each run)
    // fastp_fastq_files = FASTP(fastq_files)
    qc_fastq_files = QC(fastq_files.flatten()) // flatten() calls QC for each element of the list, so 2 (1 and 2 here)
    // It can call QC as soon as the 2 first elements of the previous process (FasterqDump here) has been completed.
    // Allows 13 -> 25 elements as inputs (because we have 2 files for each accession, and we run the QC for each FASTQ).
    // Channel: contains several elements inside, which follow each other, as a list.
    // FasterqDump: returns a list for each element of the list => Output: list of list.
    // flatten(): flattens the double list as a single list. 
    multiqc_report = MultiQC(qc_fastq_files.collect()) // collect() operator returns a list of files; waits until the
    // previous process has been completed, QC here
}

// Cardinality: very important => Check the workflow (maybe ok here)