#!/bin/bash

# Use CONCOCT to bin assemblies (coassemblies)
# It requires the contigs and the aligned BAMs.
# for contig in <contigs>; do concoct_binning_coassemblies.sh $contigs <bams directory> <outputdir>; done

contigs=$1
bamdir=$2
outdir=$3
assembly="$(basename -- $contigs | sed 's/.contigs.fa//')"

echo "CONCOCT Step 1: Cutting up the contigs"

# CONCOCT Step 1: Cut up the contigs into smaller pieces
cut_up_fasta.py $contigs -c 10000 -o 0 --merge_last -b $outdir/"$assembly"_10k.bed > $outdir/"$assembly"_10k.fa

echo "CONCOCT Step 2: Generating coverage table using the following files \n $bamdir/*"$assembly"_mapped_sorted.bam"

# CONCOCT Step 2: Generate coverage table
concoct_coverage_table.py $outdir/"$assembly"_10k.bed $bamdir/*"$assembly"_mapped_sorted.bam > $outdir/"$assembly"_coverage_table.tsv

echo "CONCOCT Step 3: Running CONCOCT"

# CONCOCT Step 3: Run CONCOCT
# Setting minimum contig length to 2000
concoct --composition_file $outdir/"$assembly"_10k.fa --coverage_file $outdir/"$assembly"_coverage_table.tsv -b $outdir/"$assembly" -l 2000 -t 10

echo "CONCOCT Step 4: Merging small contigs back to original contigs"

# CONCOCT Step 4: Merge contigs
# This uses a 'gt' file created by the previous step
merge_cutup_clustering.py $outdir/"$assembly"_clustering_gt2000.csv > $outdir/"$assembly"_merged.csv

echo "CONCOCT Step 5: Produce FASTA bins"

# CONCOCT Step 5: Extract the bins as fastas
mkdir $outdir/bins/"$assembly"
extract_fasta_bins.py $contigs $outdir/"$assembly"_merged.csv --output_path $outdir/bins/"$assembly"

# Clean up the intermediate files
rm $outdir/"$assembly"_10k.bed
rm $outdir/"$assembly"_10k.fa
rm $outdir/"$assembly"_coverage_table.tsv
rm $outdir/"$assembly"*gt2000.csv
rm $outdir/"$assembly"_merged.csv



