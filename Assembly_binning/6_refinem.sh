#!/bin/bash

# Draft genome curation by RefineM (contaminant removal)
# After dereplication and consolidation of bins from the same assembly
# Run this as one job per assembly
# for bindir in *DASTool_bins; do sbatch refinem.sh $bindir <contig dir> <bam dir> <outdir>

# Required for SSU searching
module load hmmer/3.3.1

bindir=$1
contigdir=$2
bamdir=$3
outdir=$4
assembly="$(basename -- $bindir | sed 's/_DASTool_bins//')"

### Removing contamination based on genomic properties
# Calculate tetranucleotide signature and coverage profiles for scaffolds
# If you're doing individual assemblies:
#refinem scaffold_stats -c 10 -x fa $contigdir/"$assembly"_scaffolds.fa $bindir $outdir/Stats/"$assembly" $bamdir/"$assembly"_mapped_sorted.bam
# Otherwise, for coassemblies, comment out the above and use this:
refinem scaffold_stats -c 10 -x fa $contigdir/"$assembly".contigs.fa $bindir $outdir/Stats/"$assembly" $bamdir/*"$assembly"_mapped_sorted.bam 

# Identify scaffolds with divergent genomic properties
refinem outliers $outdir/Stats/"$assembly"/scaffold_stats.tsv $outdir/Outlier/"$assembly"

### Removing contamination based on taxonomic assignments
# Call genes on genomes
refinem call_genes -c 10 -x fa $bindir $outdir/Gene/"$assembly"

# Classify genes comprising each bin against a reference database
refinem taxon_profile -c 10 $outdir/Gene/"$assembly" $outdir/Stats/"$assembly"/scaffold_stats.tsv ~/rp24_scratch/Database/RefineM_database/gtdb_r95_protein_db.2020-07-30.faa.dmnd ~/rp24_scratch/Database/RefineM_database/gtdb_r95_taxonomy.2020-07-30.tsv $outdir/Taxon_profile/"$assembly"

# Identify scaffolds with divergent taxonomic assignments
refinem taxon_filter -c 10 $outdir/Taxon_profile/"$assembly" $outdir/Taxon_profile/"$assembly"/taxon_filter.tsv

### Identify scaffolds with 16S rRNA genes that appear incongruent with taxonomic identity
# GTDB r80 is the only release with SSUs available in the RefineM files
refinem ssu_erroneous -c 10 -x fa $bindir $outdir/Taxon_profile/"$assembly" ~/rp24_scratch/Database/RefineM_database/gtdb_r80_ssu_db.2018-01-18.fna ~/rp24_scratch/Database/RefineM_database/gtdb_r80_taxonomy.2017-12-15.tsv $outdir/SSU/"$assembly"

# Remove contaminating scaffolds from bins
# Do this consecutively so all contaminating contigs are removed
refinem filter_bins -x fa $bindir $outdir/Outlier/"$assembly"/outliers.tsv $outdir/Decon_outlier/"$assembly" # Divergent genomic properties
refinem filter_bins -x fa $outdir/Decon_outlier/"$assembly" $outdir/Taxon_profile/"$assembly"/taxon_filter.tsv $outdir/Decon_taxon/"$assembly" # Divergent taxonomy by genes
refinem filter_bins -x fa $outdir/Decon_taxon/"$assembly" $outdir/SSU/"$assembly"/ssu_erroneous.tsv $outdir/Decon_ssu/"$assembly" # Divergent SSU taxonomy

# Rename bins
for bin in $outdir/Decon_ssu/"$assembly"/*.fa
do
mv $bin ${bin/filtered.filtered.filtered./}
done
