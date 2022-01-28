#!/bin/bash

# Run DIAMOND homology searches on the master functional database 
# (Contains 50 genes)

# Use this script in a loop to create one job per sample
# for file in *processed_1.fq.gz; do sbatch diamond_funcgenes.sh $file <output directory> <path to database>; done

reads=$1
outputdir=$2
db=$3

samplename="$(basename -- $reads | sed 's/_.*//')"
outfile=$outputdir/"$samplename"_50_hits_master.txt

# Run DIAMOND
diamond blastx --db $db --query $reads --out $outfile --threads 8 --outfmt 6 qtitle stitle pident length qstart qend sstart send evalue bitscore qcovhsp scovhsp --max-target-seqs 1 --max-hsps 1 --id 50

# Filter to alignments of at least 40 amino acids
filtered=${outfile/.txt/_L40.txt}
awk -F '\t' '{if ($4 >= 40) print $0}' $outfile  > $filtered

# Split the master file up into each gene for further filtering
# List the gene names first
genelist="$(awk -F '\t' '{print $2}' $filtered | sed 's/-.*/-/' | sort | uniq | sed 's/^/\^/')"

# Find hits to these and make a file for each
for gene in $genelist
do
awk -F '\t' -v var="$gene" '$2 ~ var' $filtered > $outputdir/"$samplename"_"$gene"_50_hits.txt
done



