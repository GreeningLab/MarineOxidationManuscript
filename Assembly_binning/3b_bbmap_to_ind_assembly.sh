#!/bin/bash

# Map reads to an assembly with BBMap (individual assemblies)
# Use script as one job per sample
# for forward in *processed_1.fq.gz; do bbmap_to_ind_assembly.sh $forward <contig directory> <outputdir>; done

forward=$1
reverse=${forward/_1/_2}
contigs=$2
outputdir=$3
sample="$(basename -- $forward | sed 's/_processed_1.fq.gz//')"

cd $outputdir
module load samtools/1.9

bbmap.sh in1=$forward in2=$reverse path=$contigs/"$sample"_scaffolds_bbref covstats="$sample"_coverage.txt out="$sample"_mapped.sam ambiguous=random threads=15 -Xmx50g statsfile="$sample"_bbmap.log trimreaddescriptions=t bamscript="$sample"_bs.sh

sh "$sample"_bs.sh

rm "$sample"_mapped.sam
