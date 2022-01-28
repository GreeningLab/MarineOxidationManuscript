#!/bin/bash

# This script predicts genes from a set of bins or from unbinned contigs and then finds hits to a DIAMOND database
# for file[bin/contig set] in *.fa; do sbatch gene_prediction_annotation.sh $file <single or meta> <database> <outdir>

fasta=$1
mode=$2
dmnd=$3
outdir=$4

name="$(basename -- $fasta | sed 's/.fa//')"

# Mode is either 'single' (for MAGs) or 'meta' (for unbinned contigs)
mkdir $outdir/ORFs
prodigal -p $mode -i $fasta -a $outdir/ORFs/"$name"_ORFs.fasta 

# When genes predicted, then run them through DIAMOND
mkdir $outdir/diamond_hits
diamond blastp --db $dmnd --query $outdir/ORFs/"$name"_ORFs.fasta --out $outdir/diamond_hits/"$name"_30_hits_master.txt --threads 8 --outfmt 6 qtitle stitle pident length qstart qend sstart send evalue bitscore qcovhsp scovhsp full_qseq --max-target-seqs 1 --max-hsps 1 --id 30
