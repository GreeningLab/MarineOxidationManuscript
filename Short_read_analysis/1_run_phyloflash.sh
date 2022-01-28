#!/bin/bash

# Use this script in a loop to create one job per sample
# for file in *processed_1.fq.gz; do sbatch run_phyloflash.sh $file <output directory>; done

# Load phyloflash
module load phyloflash/3.4

forward=$1
outdir=$2
reverse=${forward/_1/_2}
base="$(basename -- $forward | sed 's/_.*//')"

# Phyloflash for bacterial taxonomy (genus level)
cd $outdir
phyloFlash.pl -lib "$base" -read1 $forward -read2 $reverse -taxlevel 6 -readlength 150 -CPUs 5 -almosteverything -dbhome ~/rp24_scratch/Database/RNA_database/PhyloFlash/138

# Run it again for eukaryotic taxonomy at equivalent genus level
mkdir $outdir/euk
cd $outdir/euk
phyloFlash.pl -lib "$base" -read1 $forward -read2 $reverse -taxlevel 19 -readlength 150 -CPUs 5 -skip_spades -log -zip -dbhome ~/rp24_scratch/Database/RNA_database/PhyloFlash/138
