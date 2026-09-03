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

    // publishDir "${workflow.projectDir}/data/baoshan/prefetch/${accession}"

    input:
        path sra_folder
        val accession

    output:
        path "${accession}_1.fastq.gz" // returns a list of all fastq files in a single list in the current directory (of the process)
    // indicates where I have to take the files in the repository of the process
        path "${accession}_2.fastq.gz"

    script:
    """
    fasterq-dump ${sra_folder} --split-3 --threads 1
    gzip *.fastq
    """
}

process QC {

    conda '/home/caujoulat/miniforge3/envs/qc'

    // publishDir "${workflow.projectDir}/reports/baoshan_results/qc"

    input:
        path fastq

    output:
        //path "${fastq}.zip"
        path "${fastq.simpleName}_fastqc.html"

    script:
    """
    fastqc ${fastq}
    """
}

process FASTP {

    conda '/home/caujoulat/miniforge3/envs/fastp'

    //publishDir "${workflow.projectDir}/reports/baoshan_results/fastp"

    input:
        path fastq_R1
        path fastq_R2

    output:
        path "*.html"
        path "*.fq.gz"

    script:
    """
    fastp -i "${fastq_R1}" -I "${fastq_R2}" -o "${fastq_R1.simpleName}_out.fq.gz" -O "${fastq_R2.simpleName}_out.fq.gz"
    """
}

process POST_QC {

    conda '/home/caujoulat/miniforge3/envs/qc'

    // publishDir "${workflow.projectDir}/reports/baoshan_results/qc"

    input:
        path fastq

    output:
        //path "${fastq}.zip"
        path "${fastq.simpleName}_fastqc.html"

    script:
    """
    fastqc ${fastq}
    """
}

process MultiQC {

    conda '/home/caujoulat/miniforge3/envs/multiqc'

    // publishDir "${workflow.projectDir}/reports/baoshan_results/multiqc"

    input:
        path path2html_report // list of HTMLs and zip files, 
        // and the command echo displays the elements of the list with a space

    output:
        path "multiqc_report.html"
        path "multiqc_data"

    script:
    """
    echo ${path2html_report} | tr ' ' '\n' > baoshan_file_list.txt
    multiqc --file-list baoshan_file_list.txt
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
        .splitText() // Reads the file and generates 1 element/input per row
        .map { it.trim() } // Clean up whitespace; map() method allows application of an operation to each element of a list
    (sra_folders, accessions2) = Prefetch(accessions)
    (fastq_files_1, fastq_files_2) = FasterqDump(sra_folders, accessions2) // returns 2 lists of fastq files each time (each run)

    // 1. Pre-QC on raw data
    qc_reports_html = QC(fastq_files_1.mix(fastq_files_2)) 
    // flatten() calls QC for each element of the list, so 2 (1 and 2 here, for each accession)
    // It can call QC as soon as the 2 first elements of the previous process (FasterqDump here) has been completed.
    // Allows 13 -> 25 elements as inputs (because we have 2 files for each accession, and we run the QC for each FASTQ).
    // Channel: contains several elements inside, which follow each other, as a list.
    // FasterqDump: returns a list for each element of the list => Output: list of list.
    // flatten(): flattens the double list as a single list: takes a list of lists and returns a single list 

    // 2. QC and Trimming
    (fastp_html_reports, fastp_fastq_files) = FASTP(fastq_files_1, fastq_files_2)

    // 3. Post-QC on Trimmed Data
    // post_qc_reports_html = POST_QC(fastp_fastq_files)

    // 4. Combine all reports for MultiQC
    // multiqc_report = MultiQC(qc_fastq_files.collect()) // collect() operator returns a list of files; waits until the
    // previous process has been completed, QC here
}

// Cardinality: very important => Check the workflow (maybe ok here)