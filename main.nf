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
        path all_reports

    output:
        path "*.html"

    script:
    """
    multiqc ${all_reports}
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
    //fastp_fastq_files = FASTP(fastq_files)
    qc_fastq_files = QC(fastq_files.collect())
    multiqc_report = MultiQC(qc_fastq_files)
}