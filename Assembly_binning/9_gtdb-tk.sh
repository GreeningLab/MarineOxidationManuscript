#!/bin/bash

# Assign GTDB taxonomy to genomes
# sbatch gtdb-tk.sh <bindir> <outdir>

bindir=$1
outdir=$2

# Set path for GTDB database
export GTDBTK_DATA_PATH=~/rp24_scratch/Database/GTDB-tk/release202

# Classify genomes using GTDB taxonomy
gtdbtk classify_wf -x fa --cpus 10 --genome_dir $bindir --out_dir $outdir --prefix Marine
