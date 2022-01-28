#!/bin/bash

# Run this script once, providing the read directory, the bin directory and the output directory
# sbatch coverm.sh <readdir> <bindir> <outdir>

readdir=$1
bindir=$2
outdir=$3

# 1. Run CoverM with individual samples, to get the relative abundance per bin per sample
coverm genome -1 $readdir/*processed_1.fq.gz -2 $readdir/*processed_2.fq.gz --genome-fasta-files $bindir/*.fa -o $outdir/per_sample_coverage.txt --min-read-aligned-percent 0.75 --min-read-percent-identity 0.95 --min-covered-fraction 0

# 2. Run CoverM with all sample reads, to get the mean coverage per bin across the dataset
cat $readdir/*processed_1.fq.gz > $readdir/combined_R1.fq.gz
cat $readdir/*processed_2.fq.gz > $readdir/combined_R2.fq.gz

coverm genome -t 10 -m mean -1 $readdir/combined_R1.fq.gz -2 $readdir/combined_R2.fq.gz --genome-fasta-files $bindir/*.fa -o $outdir/per_bin_coverage_mean.txt --min-covered-fraction 0

rm $readdir/combined_R1.fq.gz
rm $readdir/combined_R2.fq.gz
