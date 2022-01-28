#!/bin/bash

# Genome dereplication using DAS_Tool

# Provide the metabat2, maxbin2 and concoct directories of bins
# Run this script per assembly
# for assembly in <individual and coassembly contigs.fa>; do sbatch dastool.sh $assembly <metabat2 dir> <maxbin2 dir> <concoct dir> <outdir>; done

assembly=$1
batdir=$2
maxdir=$3
concoctdir=$4
outdir=$5

# Grab the assembly name so it matches the directories
name="$(basename -- $assembly | sed 's/.contigs.*//; s/_scaffolds.*//' )"

echo "Making files "$name"_metabat2.scaffolds2bin.tsv, "$name"_maxbin2.scaffolds2bin.tsv and "$name"_concoct.scaffolds2bin.tsv"

# Take the set of bins for each tool and create a scaffolds2bin file as input to DAStool (two columns indicating which contig belongs in which bin)
Fasta_to_Scaffolds2Bin.sh -i $batdir/"$name" -e fa > $outdir/"$name"_metabat2.scaffolds2bin.tsv
Fasta_to_Scaffolds2Bin.sh -i $maxdir/"$name" -e fa > $outdir/"$name"_maxbin2.scaffolds2bin.tsv
Fasta_to_Scaffolds2Bin.sh -i $concoctdir/"$name" -e fa > $outdir/"$name"_concoct.scaffolds2bin.tsv

echo "Running DAS_Tool"

# Run DAS_Tool
cd $outdir
DAS_Tool -i "$name"_metabat2.scaffolds2bin.tsv,"$name"_maxbin2.scaffolds2bin.tsv,"$name"_concoct.scaffolds2bin.tsv --search_engine diamond --write_bins 1 --score_threshold 0.10 -t 10 -c $assembly -o "$name"

