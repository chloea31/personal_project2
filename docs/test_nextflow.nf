#!/usr/bin/env nextflow

// Declare synthax version
nextflow.enable.dsl=2 

process CreateFile {

    publishDir "nextflow/${acc}"

    input:
        val acc

    output:
        path "toto.txt"

    script:
    """
    echo "I like ${acc}" > toto.txt
    """
}

workflow {
    values = Channel.fromList(["swimming", "doing gymnastic"])
    text_file = CreateFile(values)
}