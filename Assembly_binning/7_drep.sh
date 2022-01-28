#!/bin/bash

# Dereplicate a set of bins into one final set
# Run this script once, providing the directory where the bins are and the output directory:
# sbatch drep.sh <bindir> <outdir>


bindir=$1
outdir=$2

# -p is threads, -comp is the minimum genome completeness, and -con the maximum contamination (both as %)
# The default ANI to dereplicate at here is 99%
dRep dereplicate $outdir -g $bindir/*.fa -p 10 -comp 50 -con 10

# Remove intermediate files
rm -r $outdir/data
