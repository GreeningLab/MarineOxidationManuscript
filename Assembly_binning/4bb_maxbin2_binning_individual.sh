#!/bin/bash

# Use MaxBin2 to bin assemblies (individual assemblies)
# It requires the contigs and the contig coverage.
# for contigs in <contigs>; do metabat2_binning.sh $contigs <coverage directory> <outputdir>; done

contigs=$1
covdir=$2
outdir=$3
sample="$(basename -- $contigs | sed 's/_scaffolds.fa//')"

# Minimum contig length of 2000 bp
# For individual assemblies, one coverage file given (this is the contig name and avg coverage from BBMap covstats)

# Place in a separate directory per assembly, to make things a little neater
mkdir $outdir/"$sample"_individual
run_MaxBin.pl -contig $contigs -abund $covdir/"$sample"_coverage_maxbin2.txt -out $outdir/"$sample"_individual/"$sample" -min_contig_length 2000 -thread 10


# Remove the large intermediate files not required
rm $outdir/"$sample"_individual/*.tooshort
rm $outdir/"$sample"_individual/*.noclass

