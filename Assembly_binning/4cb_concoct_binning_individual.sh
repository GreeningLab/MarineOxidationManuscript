#!/bin/bash

# Use CONCOCT to bin assemblies (individual assemblies)
# It requires the contigs and the aligned BAMs.
# for contig in <contigs>; do concoct_binning_individual.sh $contigs <bams directory> <outputdir>; done

contigs=$1
bamdir=$2
outdir=$3
sample="$(basename -- $contigs | sed 's/_scaffolds.fa//')"

echo "CONCOCT Step 1: Cutting up the contigs"

# CONCOCT Step 1: Cut up the contigs into smaller pieces
cut_up_fasta.py $contigs -c 10000 -o 0 --merge_last -b $outdir/"$sample"_10k.bed > $outdir/"$sample"_10k.fa

echo "CONCOCT Step 2: Generating coverage table"

# CONCOCT Step 2: Generate coverage table
concoct_coverage_table.py $outdir/"$sample"_10k.bed $bamdir/"$sample"_mapped_sorted.bam > $outdir/"$sample"_coverage_table.tsv

echo "CONCOCT Step 3: Running CONCOCT"

# CONCOCT Step 3: Run CONCOCT
# Setting minimum contig length to 2000
concoct --composition_file $outdir/"$sample"_10k.fa --coverage_file $outdir/"$sample"_coverage_table.tsv -b $outdir/"$sample" -l 2000 -t 10

echo "CONCOCT Step 4: Merging small contigs back to original contigs"

# CONCOCT Step 4: Merge contigs
# This uses a 'gt' file created by the previous step
merge_cutup_clustering.py $outdir/"$sample"_clustering_gt2000.csv > $outdir/"$sample"_merged.csv

echo "CONCOCT Step 5: Produce FASTA bins"

# CONCOCT Step 5: Extract the bins as fastas
mkdir $outdir/bins/"$sample"
extract_fasta_bins.py $contigs $outdir/"$sample"_merged.csv --output_path $outdir/bins/"$sample"

# Clean up the intermediate files
rm $outdir/"$sample"_10k.bed
rm $outdir/"$sample"_10k.fa
rm $outdir/"$sample"_coverage_table.tsv
rm $outdir/"$sample"*gt2000.csv
rm $outdir/"$sample"_merged.csv



