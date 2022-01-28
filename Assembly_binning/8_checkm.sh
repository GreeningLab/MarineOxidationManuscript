#!/bin/bash

# Runs CheckM to provide completeness and contamination stats for bins
# Run this script once, providing the directory where the final bins are and the output directory:
# sbatch checkm.sh <bindir> <outdir>

bindir=$1
outdir=$2

checkm lineage_wf -t 20 --pplacer_threads 10 -x fa --tab_table -f $outdir/bin_summary.txt $bindir $outdir
