#!/bin/bash

# Assemble metagenomes with MEGAHIT
# Use this script as one job per sample:
# for forward in *R1.fq.gz; do sbatch megahit.sh $forward <outputdir> ; done

module load megahit/1.2.9

# Variables given to script
forward=$1
outputdir=$2
reverse=${forward/R1/R2}
base="$(basename -- $forward | sed 's/_R1.fq.gz//')"

# Megahit is a tool that complains if the directory exists, so we must make one for each sample inside the main output directory
megahit -1 $forward -2 $reverse -t 20 -m 2.40e11 --min-contig-len 500 --k-list 27,37,47,57,67,77,87,97,107,117,127 -o $outputdir/"$base" --out-prefix $base
