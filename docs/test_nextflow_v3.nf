#!/usr/bin/env nextflow

// Declare synthax version
nextflow.enable.dsl=2 

process P1 {
    publishDir "test/${toto}"

    input:
        val toto

    output:
        path "${toto}"
        val "${toto}"

    script:
    """
    echo "Hello" > ${toto}
    """
}

process P2 {
    publishDir "test/${tutu}"

    input:
        path toto
        val tutu

    output:
        path "${tutu}_1.txt.gz"
        path "${tutu}_2.txt.gz"

    script:
    """
    echo "Hey ${tutu} \$(cat ${toto})" > ${tutu}_1.txt
    echo "Hey ${tutu} \$(cat ${toto})" > ${tutu}_2.txt
    gzip *.txt
    """
}

process P3 {
    input:
        path toto

    output:
        path "${toto.baseName}.{zip,html}"

    script:
    """
    cp ${toto} ${toto.baseName}.zip
    cp ${toto} ${toto.baseName}.html
    """
}

workflow {
    i = Channel.of(['best1', 'best2', 'best3'])
    (p, v) = P1(i.flatten())
    (p2_1, p2_2) = P2(p, v)
    pc = P3(p2_1.mix(p2_2))
}