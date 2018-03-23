#!/usr/bin/env bash

set -o errexit

# Source parameter files
source /mnt/nexenta/lanno001/nobackup/int_ab_20180321/extended_parameters.config
source /home/lanno001/assemblerBenchmark/parameters_toolpaths.config

# Create working directory
mkdir -p /mnt/nexenta/lanno001/nobackup/int_ab_20180321/assembler_results/minimap_miniasm

# Run assembler and copy assembly fasta to separate folder

# ASSEMBLER COMMAND SCRIPT
# TOOL DESCRIPTION-----------------------------------------------------------------------------------------
#
# Minimap is a fast all-vs-all mapper of reads that relies on sketches of sequences, composed of
# minimizers. It was succeded by minimap2. Miniasm uses the found overlaps to construct an assembly graph.
# As a consensus step is lacking in this pipeline, post-assembly polishing is often required. In this
# case, Nanopolish was used.
#
# VERSIONS-------------------------------------------------------------------------------------------------
# minimap: <${MINIMAP} -V>
# miniasm: <${MINIASM} -V>
#
# COMMANDS-------------------------------------------------------------------------------------------------


${MINIMAP} -x ava10k -t ${NB_THREADS} ${INT}/all_reads.fastq ${INT}/all_reads.fastq | gzip -1 > ${INT}/assembler_results/minimap_miniasm/minimap.paf.gz && (${MINIASM} -f ${INT}/all_reads.fastq ${INT}/assembler_results/minimap_miniasm/minimap.paf.gz > ${INT}/assembler_results/minimap_miniasm/minimap_miniasm.gfa)
awk '/^S/{print ">"$2"\n"$3}' ${INT}/assembler_results/minimap_miniasm/minimap_miniasm.gfa | fold > ${INT}/assembler_results/minimap_miniasm/minimap_miniasm.fasta

cp ${INT}/assembler_results/minimap_miniasm/minimap_miniasm.fasta ${INT}/assembler_results/all_assemblies/minimap_miniasm.fasta

echo "START AUTO VERSION PRINTING"
grep -Pzo '(?s)(?<=VERSIONS\-{97}\n).+(?=# COMMANDS)' ${BASH_SOURCE[0]} | grep -aPo '#.+(?=: <)'

${MINIMAP} -V 2>&1 && ${MINIASM} -V 2>&1 && echo "END AUTO VERSION PRINTING"
