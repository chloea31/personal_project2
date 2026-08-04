#!/usr/bin/env nextflow

// Declare synthax version
nextflow.enable.dsl=2 

process fetch {
    publishDir "test/fetch"

    input:
        val acc

    output:
        path "${acc}"
        val "${acc}"

    script:
    """
    mkdir -p ${acc}
    echo "Je mange des ${acc}" > ${acc}/toto.txt
    echo "Je range des ${acc}" > ${acc}/tata.txt
    """
}

process dump {
    publishDir "test/fetch/${acc}"

    input:
        path tutu
        val acc

    output:
        path "*.qvq"

    script:
    """
    echo "Je mange des ${acc}" > toto.qvq
    echo "Je range des ${acc}" > tata.qvq
    """
}

workflow {
    accs = Channel.fromList(["heto", "azi"])
    (totos, accs2) = fetch(accs)
    qvqs = dump(totos, accs2)
}