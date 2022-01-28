#!/bin/bash

# Assemble a metagenome with metaSPAdes
# Use this script as one job per sample:
# for forward in *_1.fq.gz; do sbatch ~/bin/slurm_scripts/metaspades.sh $forward <outputdir>; done

source ~/miniconda3/etc/profile.d/conda.sh
conda activate metaspades

# Variables given to script
forward=$1
reverse=${forward/_1/_2}
outputdir=$2
base="$(basename -- $forward | sed 's/_1.fq.gz//')"

# To match megahit, output one directory per sample
metaspades.py -1 $forward -2 $reverse -t 20 -m 295 -k 27,37,47,57,67,77,87,97,107,117,127 -o $outputdir/"$base"

# Continue an interrupted run (only after assembly starts, cannot continue partway through error correction)
#metaspades.py -o $outputdir --continue
