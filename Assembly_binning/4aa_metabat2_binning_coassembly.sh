#!/bin/bash

# Use MetaBAT2 to bin assemblies (coassemblies)
# It requires the contigs and the sorted bam file.
# for contigs in <contigs>; do metabat2_binning.sh $contigs <bams directory> <outputdir>; done

contigs=$1
bamdir=$2
outdir=$3
assembly="$(basename -- $contigs | sed 's/.contigs.fa//')"

module load metabat/2.15.5

# Minimum contig length of 2000 bp
# For coassemblies, multiple .bam files given - they contain the coassembly name
# With this wrapper script, you can't specify the output so it needs to be somewhere sensible, then moved
cd $bamdir

runMetaBat.sh --minContig 2000 -t 12 -v $contigs *_"$assembly"_mapped_sorted.bam 

mv "$assembly".contigs.fa.metabat-bins* $outdir
mv "$assembly".contigs.fa.depth.txt $outdir


