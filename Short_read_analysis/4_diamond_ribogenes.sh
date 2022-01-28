#!/bin/bash

# Run DIAMOND homology searches on the master ribosomal protein database
# (Contains 14 genes)

# Use this script in a loop to create one job per sample
# for file in *processed_1.fq.gz; do sbatch diamond_ribogenes.sh $file <output directory> <path to database>; done

reads=$1
outputdir=$2
db=$3

samplename="$(basename -- $reads | sed 's/_.*//')"
outfile=$outputdir/"$samplename"_hits.txt

# Run DIAMOND (no %ID requirement here)
diamond blastx --db $db --query $reads --out $outfile --threads 8 --outfmt 6 qtitle stitle pident length qstart qend sstart send evalue bitscore --max-target-seqs 1 --max-hsps 1

# Filter to alignments of at least 40 amino acids, to match what we do for funcgenes
filtered=${outfile/.txt/_L40.txt}
awk -F '\t' '{if ($4 >= 40) print $0}' $outfile  > $filtered
