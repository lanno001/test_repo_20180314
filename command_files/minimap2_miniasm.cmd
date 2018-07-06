minimap2 -x ava-ont -t 4 {input.fastq} {input.fastq} | gzip -1 > minimap2.paf.gz
miniasm -f {input.fastq} minimap2.paf.gz > minimap2_miniasm.gfa
grep -Po '(?<=S\t).+(?=\[M::main\])' minimap2_miniasm.gfa | awk '{{print ">"$1"\\n"$2}}' | fold > {output}
