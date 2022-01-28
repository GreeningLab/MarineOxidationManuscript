#!/bin/bash

# Use MetaBAT2 to bin assemblies (individual assemblies)
# It requires the contigs and the sorted bam file.
# for contigs in <contigs>; do metabat2_binning.sh $contigs <bams directory> <outputdir>; done

contigs=$1
bamdir=$2
outdir=$3
sample="$(basename -- $contigs | sed 's/_scaffolds.fa//')"

module load metabat/2.15.5

# Minimum contig length of 2000 bp
# For individual assemblies, one .bam file given
# With this wrapper script, you can't specify the output so it needs to be somewhere sensible, then moved
cd $bamdir

runMetaBat.sh --minContig 2000 -t 12 -v $contigs "$sample"_mapped_sorted.bam

mv "$sample"_scaffolds.fa.metabat-bins* $outdir
mv "$sample"_scaffolds.fa.depth.txt $outdir

