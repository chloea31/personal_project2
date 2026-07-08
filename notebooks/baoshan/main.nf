#!/usr/bin/env nextflow

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*       ANALYSIS OF GENOMIC DATA FROM BAOSHAN MIMIVIRUS      */
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

// Declare synthax version
nextflow.enable.dsl=2 

// Initialize default parameters
params.help = true

// Getting help message
// if ( params.help ) {
//     help = """--
//         |Mandatory arguments:
//         |Optional arguments:
//     --
//     """.stripMargin()
//     println(help)
// }

// Defining processes

process downloadFiles { 

    publishDir '${workflow.projectDir}/data/baoshan/prefetch'

    conda '/home/caujoulat/miniforge3/envs/download_data_viruses'

    input:
        text_file

    output:
        path "${workflow.projectDir}/data/baoshan/prefetch/*.sra"
        path "${workflow.projectDir}/data/baoshan/prefetch/*.fastq.gz"

    script:
    """
    prefetch --progress ${accession}
    """
}

workflow {
    
}