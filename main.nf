#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.input = 'BPC-20-NC-2405-002.scn'
params.outDir = 'outputs'

process count_scenes {
    input:
      path x

    output:
      stdout

    script:
      """
      tiffcomment $x| grep -c '</image>'
      """
}

process bioformats2raw {
    input:
      tuple path(scn_file), val(series)

    output:
      path '*'

    script:
      """
      bioformats2raw --series $series $scn_file $scn_file.simpleName-series$series --progress --target-min-size 512
      """
}

process clean_ome {
    input:
      path raw

    output:
      path raw

    script:
      """
      python ${projectDir}/bin/clean_ome.py '$raw/OME/METADATA.ome.xml' > clean.xml
      cat clean.xml > '$raw/OME/METADATA.ome.xml'
      rm -f clean.xml
      """
}

process raw2ometiff {
    publishDir "${params.outDir}/", mode: 'copy'
    input:
      path raw


    output:
      path '*.ome.tiff'

    script:
      """
      raw2ometiff $raw ${raw}.ome.tiff --progress --rgb --compression JPEG
      """
}

workflow {
    data = channel.fromPath(params.input)
    count_scenes(data)
    scenes = count_scenes.out
      .toInteger()
      .flatMap { 1..it-1 }

    input=  data.combine(scenes)
    bioformats2raw(input)
    clean_ome(bioformats2raw.out)
    raw2ometiff(clean_ome.out)
}
