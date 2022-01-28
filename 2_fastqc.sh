#!/bin/bash

# Run FastQC on files. Run this in a loop to create one job per file:
#for file in *.fastq.gz; do sbatch fastqc.sh $file <output directory>; done

input_file=$1
output_dir=$2

module load fastqc/0.11.7

# Run fastqc across all forward and reverse reads
fastqc $input_file -o $output_dir -t 5
